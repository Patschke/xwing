###
    X-Wing Squad Builder 2.5
    Stephen Kim <raithos@gmail.com>
    https://yasb.app
###
exportObj = exports ? this

exportObj.sortHelper = (a, b) ->
    if a.points == b.points
        a_name = a.text.replace(/[^a-z0-9]/ig, '')
        b_name = b.text.replace(/[^a-z0-9]/ig, '')
        if a_name == b_name
            0
        else
            if a_name > b_name then 1 else -1
    else if typeof(a.points) == "string" # handling cases where points value is "*" instead of a number
        1
    else 
        if a.points > b.points then 1 else -1

exportObj.toTTS = (txt) ->
    if not txt?
        null
    else 
        txt.replace(/\(.*\)/g,"").replace("�",'"').replace("�",'"')

exportObj.slotsMatching = (slota, slotb) ->
    return true if slota == slotb
    switch slota
        when 'HardpointShip'
            return true if slotb == 'Torpedo' or slotb == 'Cannon' or slotb == 'Missile'
        when 'VersatileShip'
            return true if slotb == 'Torpedo' or slotb == 'Missile'
    switch slotb
        when 'HardpointShip'
            return true if slota == 'Torpedo' or slota == 'Cannon' or slota == 'Missile'
        when 'VersatileShip'
            return true if slota == 'Torpedo' or slota == 'Missile'
    return false

$.isMobile = ->
    if (navigator.userAgent.match /(iPhone|iPod|iPad|Android)/i) or navigator.maxTouchPoints > 1
        return true
    return false
    

$.randomInt = (n) ->
    Math.floor(Math.random() * n)

$.isElementInView = (element, fullyInView) ->
    pageTop = $(window).scrollTop()
    pageBottom = pageTop + $(window).height()
    elementTop = $(element)?.offset()?.top
    elementBottom = elementTop + $(element).height()

    if fullyInView
        return ((pageTop < elementTop) && (pageBottom > elementBottom))
    else
        return ((elementTop <= pageBottom) && (elementBottom >= pageTop))


# ripped from http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values
$.getParameterByName = (name) ->
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]")
    regexS = "[\\?&]" + name + "=([^&#]*)"
    regex = new RegExp(regexS)
    results = regex.exec(window.location.search)
    if results == null
        return ""
    else
        return decodeURIComponent(results[1].replace(/\+/g, " "))

Array::intersects = (other) ->
    for item in this
        if item in other
            return true
    return false

Array::removeItem = (item) ->
    idx = @indexOf item
    @splice(idx, 1) unless idx == -1
    this

String::capitalize = ->
    @charAt(0).toUpperCase() + @slice(1)

String::getXWSBaseName = ->
    @split('-')[0]

URL_BASE = "#{window.location.protocol}//#{window.location.host}#{window.location.pathname}"
SQUAD_DISPLAY_NAME_MAX_LENGTH = 24

statAndEffectiveStat = (base_stat, effective_stats, key) ->
    if base_stat?
        """#{base_stat}#{if (effective_stats? and effective_stats[key]? and effective_stats[key] != base_stat) then " (#{effective_stats[key]})" else ""}"""
    else if effective_stats? and effective_stats[key]?
        """0 (#{effective_stats[key]})"""
    else
        "0"

getPrimaryFaction = (faction) ->
    switch faction
        when 'Rebel Alliance'
            'Rebel Alliance'
        when 'Galactic Empire'
            'Galactic Empire'
        else
            faction

conditionToHTML = (condition) ->
    html = $.trim """
        <div class="condition">
            <div class="name">#{if condition.unique then "&middot;&nbsp;" else ""}#{if condition.display_name then condition.display_name else condition.name}</div>
            <div class="text">#{condition.text}</div>
        </div>
    """

# Assumes cards.js will be loaded

class exportObj.SquadBuilder
    constructor: (args) ->
        # args
        @container = $ args.container
        @faction = $.trim args.faction
        @printable_container = $ args.printable_container
        @tab = $ args.tab
        @show_points_destroyed = false
        
        @isCurrentlyLoadingSquad = false

        # internal state
        @ships = []
        @uniques_in_use =
            Pilot:
                []
            Upgrade:
                []
            Slot:
                []
        @standard_list =
            Upgrade:
                []
            Ship:
                []
        @suppress_automatic_new_ship = false
        @tooltip_currently_displaying = null
        @randomizer_options =
            sources: null
            points: 20
            ship_limit: 0
            collection_only: true
            fill_zero_pts: false
        @total_points = 0
        # a squad given in the link is loaded on construction of that builder. It will set all gamemodes of already existing builders accordingly, but we did not exists back than. So we copy over the gamemode
        @isStandard = exportObj.builders[0]?.isStandard ? false
        @isEpic = exportObj.builders[0]?.isEpic ? false
        @isXwa = exportObj.builders[0]?.isXwa ? true
        @isQuickbuild = exportObj.builders[0]?.isQuickbuild ? false

        @backend = null
        @current_squad = {}

        # todo: remove? The translation file should take care of languge management. 
        @language = exportObj.currentLanguage ? 'English'

        @collection = null

        @current_obstacles = []

        @setupUI()
        if @faction == "All"
            @game_type_selector.val("epic").trigger('change')
        else
            @game_type_selector.val((exportObj.builders[0] ? @).game_type_selector.val()).trigger('change')
        @setupEventHandlers()

        window.setInterval @updatePermaLink, 250

        @isUpdatingPoints = false

        if $.getParameterByName('f') == @faction
            @resetCurrentSquad(true)
            @loadFromSerialized $.getParameterByName('d')
        else
            @resetCurrentSquad()
            @addShip()

    resetCurrentSquad: (initial_load=false) ->
        default_squad_name = @uitranslation('Unnamed Squadron')

        squad_name = $.trim(@squad_name_input.val()) or default_squad_name
        if initial_load and $.trim $.getParameterByName('sn')
            squad_name = $.trim $.getParameterByName('sn')

        squad_obstacles = []
        if initial_load and $.trim $.getParameterByName('obs')
            squad_obstacles = ($.trim $.getParameterByName('obs')).split(",").slice(0, 3)
            @updateObstacleSelect squad_obstacles
        else if @current_obstacles
            squad_obstacles = @current_obstacles

        @current_squad =
            id: null
            name: squad_name
            dirty: false
            additional_data:
                points: @total_points
                description: ''
                cards: []
                notes: ''
                obstacles: squad_obstacles
                tag: ''
            faction: @faction

        if @total_points > 0
            if squad_name == default_squad_name
                @current_squad.name = @uitranslation('Unsaved Squadron')
            @current_squad.dirty = true
        
        @old_version_container.toggleClass 'd-none', true

        @container.trigger 'xwing-backend:squadNameChanged'
        @container.trigger 'xwing-backend:squadDirtinessChanged'

    newSquadFromScratch: (squad_name = @uitranslation('New Squadron')) ->
        @squad_name_input.val squad_name
        @removeAllShips()
        @addShip() if not @suppress_automatic_new_ship
        @updateObstacleSelect []
        @resetCurrentSquad()
        @notes.val ''
        @tag.val ''

    uitranslation: (what, args...) ->
        exportObj.translate('ui', what, args)

    setupUI: ->
        DEFAULT_RANDOMIZER_POINTS = 20
        DEFAULT_RANDOMIZER_TIMEOUT_SEC = 4
        DEFAULT_RANDOMIZER_SHIP_LIMIT = 0

        @status_container = $ document.createElement 'DIV'
        @status_container.addClass 'container-fluid'
        @status_container.append $.trim """
            <div class="row squad-name-and-points-row">
                <div class="col-md-3 squad-name-container">
                    <div class="display-name">
                        <span class="squad-name"></span>
                        <i class="far fa-edit"></i>
                    </div>
                    <div class="input-append">
                        <input type="text" maxlength="64" placeholder="#{@uitranslation("Name your squad...")}" />
                        <button class="btn save"><i class="fa fa-pen-square"></i></button>
                    </div>
                    <br class="hide-on-mobile" />
                    <select class="game-type-selector">
                        <option value="xwa" class="translated" defaultText="XWA" selected="selected">#{@uitranslation("XWA")}</option>
                        <option value="standard" class="translated" defaultText="Standard">#{@uitranslation("Standard")}</option>
                        <option value="extended" class="translated" defaultText="Extended">#{@uitranslation("Extended")}</option>
                        <option value="epic" class="translated" defaultText="Epic">#{@uitranslation("Epic")}</option>
                        <option value="quickbuild" class="translated" defaultText="Quickbuild">#{@uitranslation("Standard")}</option>
                    </select>
                </div>
                <div class="col-md-4 points-display-container">
                    Points: <span class="total-points">0</span> / <input type="number" class="desired-points" value="20">
                    <span class="points-remaining-container">(<span class="points-remaining"></span>&nbsp;left) <span class="points-destroyed red"></span></span>
                    <span class="content-warning unreleased-content-used d-none"><br /><i class="fa fa-exclamation-circle"></i>&nbsp;<span class="translated" defaultText="Unreleased content warning"></span></span>
                    <span class="content-warning loading-failed-container d-none"><br /><i class="fa fa-exclamation-circle"></i>&nbsp;<span class="translated" defaultText="Broken squad link warning"></span></span>
                    <span class="content-warning old-version-container d-none"><br /><i class="fa fa-exclamation-circle"></i>&nbsp;<span class="translated" defaultText="This squad was created for an older version of X-Wing."></span></span>
                    <span class="content-warning collection-invalid d-none"><br /><i class="fa fa-exclamation-circle"></i>&nbsp;<span class="translated" defaultText="Collection warning"></span></span>
                    <span class="content-warning ship-number-invalid-container d-none"><br /><i class="fa fa-exclamation-circle"></i>&nbsp;<span class="translated" defaultText="Ship number warning"></span></span>
                    <span class="content-warning multi-faction-warning-container d-none"><br /><i class="fa fa-exclamation-circle"></i>&nbsp;<span class="translated" defaultText="Multi-Faction warning"></span></span>
                    <span class="content-warning epic-not-legal-container d-none"><br /><i class="fa fa-exclamation-circle"></i>&nbsp;<span class="translated" defaultText="Epic Unofficial"></span></span>
                </div>
                <div class="col-md-5 float-right button-container">
                    <div class="btn-group float-right">

                        <button class="btn btn-info view-as-text"><span class="d-none d-lg-block"><i class="fa fa-print"></i>&nbsp;<span class="translated" defaultText="Print/Export"></span></span><span class="d-lg-none"><i class="fa fa-print"></i></span></button>
                        <a class="btn btn-primary d-none collection"><span class="d-none d-lg-block"><i class="fa fa-folder-open"></i> <span class="translated" defaultText="Your Collection"></span></span><span class="d-lg-none"><i class="fa fa-folder-open"></i></span></a>
                        <!-- Randomize button is marked as danger, since it creates a new squad -->
                        <button class="btn btn-danger randomize"><span class="d-none d-lg-block"><i class="fa fa-random"></i> <span class="translated" defaultText="Randomize!"></span></span><span class="d-lg-none"><i class="fa fa-random"></i></span></button>
                        <button class="btn btn-danger dropdown-toggle" data-toggle="dropdown">
                            <span class="caret"></span>
                        </button>
                         <ul class="dropdown-menu dropdown-menu-right">
                            <li><a class="dropdown-item randomize-options translated" defaultText="Randomizer Options"></a></li>
                            <li><a class="dropdown-item misc-settings translated" defaultText="Misc Settings"></a></li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="row squad-save-buttons">
                <div class="col-md-12 squad-save-buttons-container">
                    <button class="show-authenticated btn btn-primary save-list"><i class="far fa-save"></i>&nbsp;<span class="translated" defaultText="Save"></span></button>
                    <button class="show-authenticated btn btn-primary save-list-as"><i class="far fa-file"></i>&nbsp;<span class="translated" defaultText="Save As..."></span></button>
                    <button class="show-authenticated btn btn-primary delete-list disabled"><i class="fa fa-trash"></i>&nbsp;<span class="translated" defaultText="Delete"></span></button>
                    <button class="show-authenticated btn btn-info backend-list-my-squads show-authenticated"><i class="fa fa-download"></i>&nbsp;<span class = "translated" defaultText="Load Squad"></span></button>
                    <button class="btn btn-info import-squad"><i class="fa fa-file-import"></i>&nbsp;<span class="translated" defaultText="Import"></span></button>
                    <button class="btn btn-info show-points-destroyed"><i class="fas fa-bullseye"></i>&nbsp;<span class="show-points-destroyed-span translated" defaultText="#{@uitranslation("Show Points Destroyed")}"></span></button>                    
                    <button class="btn btn-danger clear-squad"><i class="fa fa-plus-circle"></i>&nbsp;<span class="translated" defaultText="New Squad"></span></button>
                    <span class="show-authenticated backend-status"></span>
                </div>
            </div>
        """ 
        @container.append @status_container

        @xws_import_modal = $ document.createElement 'DIV'
        @xws_import_modal.addClass 'modal fade import-modal d-print-none'
        @xws_import_modal.tabindex = "-1"
        @xws_import_modal.role = "dialog"
        @xws_import_modal.append $.trim """
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="translated" defaultText="XWS Import"></h3>
                <button type="button" class="close d-print-none" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <span class="translated" defaultText="XWS Import Dialog"></span>
                <div class="container-fluid">
                    <textarea class="xws-content" placeholder='"""+@uitranslation("Paste XWS here")+"""'></textarea>
                </div>
            </div>
            <div class="modal-footer d-print-none">
                <span class="xws-import-status"></span>&nbsp;
                <button class="btn btn-danger import-xws translated" defaultText="Import"></button>
            </div>
        </div>
    </div>
        """
        @from_xws_button = @container.find('button.import-squad')
        @from_xws_button.click (e) =>
            e.preventDefault()
            @xws_import_modal.find('.xws-import-status').text ' '
            @xws_import_modal.modal 'show'

        @load_xws_button = $ @xws_import_modal.find('button.import-xws')
        @load_xws_button.click (e) =>
            e.preventDefault()
            exportObj.loadXWSButton(@xws_import_modal)
        @container.append @xws_import_modal

        @list_modal = $ document.createElement 'DIV'
        @list_modal.addClass 'modal fade text-list-modal'
        @list_modal.tabindex = "-1"
        @list_modal.role = "dialog"
        @container.append @list_modal
        @list_modal.append $.trim """
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <div class="d-print-none">
                    <h4 class="modal-title"><span class="squad-name"></span> <span class="total-points"></span></h4>
                </div>
                <div class="d-none d-print-block">
                    <div class="fancy-header">
                        <div class="squad-name"></div>
                        <div class="squad-faction"></div>
                        <div class="mask">
                            <div class="outer-circle">
                                <div class="inner-circle">
                                    <span class="total-points"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="fancy-under-header"></div>
                </div>
                <button type="button" class="close d-print-none" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <div class="fancy-list"></div>
                <div class="simple-list"></div>
                <div class="simplecopy-list">
                    <span class="translated" defaultText="Copy below simple text"></span>
                    <textarea></textarea><button class="btn btn-modal btn-copy translated" defaultText="Copy"></button>
                </div>
                <div class="reddit-list">
                    <span class="translated" defaultText="Copy below markdown"></span>
                    <textarea></textarea><button class="btn btn-modal btn-copy translated" defaultText="Copy"></button>
                </div>
                <div class="tts-list">
                    <span class="translated" defaultText="Copy below TTS"></span>
                    <textarea></textarea><button class="btn btn-modal btn-copy translated" defaultText="Copy"></button>
                </div>
                <div class="xws-list">
                    <span class="translated" defaultText="Copy below XWS"></span>
                    <div class="row full-row">
                        <div class="col d-inline-block d-none d-sm-block"><textarea></textarea><br /><button class="btn btn-modal btn-copy translated" defaultText="Copy"></button></div>
                        <div class="col d-inline-block d-none d-sm-block qrcode-container" id="xws-qrcode-container"></div>
                    </div>
                </div>
            </div>
            <div class="container-fluid modal-footer d-print-none">
                <div class="row full-row">
                    <div class="col d-inline-block d-none d-sm-block right-col">
                        <label class="color-skip-text-checkbox">
                            <span class="translated" defaultText="Skip Card Text"></span> <input type="checkbox" class="toggle-skip-text-print" />
                        </label><br />
                        <label class="horizontal-space-checkbox">
                            <span class="translated" defaultText="Space for Cards"></span> <input type="checkbox" class="toggle-horizontal-space" />
                        </label><br />
                        <label class="maneuver-print-checkbox">
                            <span class="translated" defaultText="Include Maneuvers Chart"></span> <input type="checkbox" class="toggle-maneuver-print" />
                        </label><br />
                        <label class="expanded-shield-hull-print-checkbox">
                            <span class="translated" defaultText="Expand Shield and Hull"></span> <input type="checkbox" class="toggle-expanded-shield-hull-print" />
                        </label>
                    </div>
                    <div class="col d-inline-block d-none d-sm-block right-col">
                        <label class="color-print-checkbox">
                            <span class="translated" defaultText="Print Color"></span> <input type="checkbox" class="toggle-color-print" checked="checked" />
                        </label><br />
                        <label class="qrcode-checkbox">
                            <span class="translated" defaultText="Include QR codes"></span> <input type="checkbox" class="toggle-juggler-qrcode" checked="checked" />
                        </label><br />
                        <label class="obstacles-checkbox">
                            <span class="translated" defaultText="Include Obstacle Choices"></span> <input type="checkbox" class="toggle-obstacles" checked="checked" />
                        </label>
                    </div>
                </div>
                <div class="row btn-group list-display-mode">
                    <button class="btn btn-modal select-simple-view translated" defaultText="Simple"></button>
                    <button class="btn btn-modal select-fancy-view translated" defaultText="Fancy"></button>
                    <button class="btn btn-modal select-simplecopy-view translated" defaultText="Text"></button>
                    <button class="btn btn-modal select-reddit-view translated" defaultText="Reddit"></button>
                    <button class="btn btn-modal select-tts-view d-none d-sm-block translated" defaultText="TTS"></button>
                    <button class="btn btn-modal select-xws-view translated" defaultText="XWS"></button>
                </div>
                <div class="row btn-group list-display-mode">
                    <button class="btn btn-modal copy-url translated" defaultText="Copy URL"></button>
                    <button class="btn btn-modal print-list d-sm-block"><span class="d-none d-lg-block"><i class="fa fa-print"></i>&nbsp;<span class="translated" defaultText="Print"></span></span><span class="d-lg-none"><i class="fa fa-print"></i></span></button>
                </div>
            </div>
        </div>
    </div>
        """
        @fancy_container = $ @list_modal.find('.fancy-list')
        @fancy_total_points_container = $ @list_modal.find('div.modal-header .total-points')
        @simple_container = $ @list_modal.find('div.modal-body .simple-list')
        @reddit_container = $ @list_modal.find('div.modal-body .reddit-list')
        @reddit_textarea = $ @reddit_container.find('textarea')
        @reddit_textarea.attr 'readonly', 'readonly'
        @simplecopy_container = $ @list_modal.find('div.modal-body .simplecopy-list')
        @simplecopy_textarea = $ @simplecopy_container.find('textarea')
        @simplecopy_textarea.attr 'readonly', 'readonly'
        @tts_container = $ @list_modal.find('div.modal-body .tts-list')
        @tts_textarea = $ @tts_container.find('textarea')
        @tts_textarea.attr 'readonly', 'readonly'
        @xws_container = $ @list_modal.find('div.modal-body .xws-list')
        @xws_textarea = $ @xws_container.find('textarea')
        @xws_textarea.attr 'readonly', 'readonly'
        @toggle_vertical_space_container = $ @list_modal.find('.horizontal-space-checkbox')
        @toggle_color_print_container = $ @list_modal.find('.color-print-checkbox')
        @toggle_color_skip_text = $ @list_modal.find('.color-skip-text-checkbox')
        @toggle_maneuver_dial_container = $ @list_modal.find('.maneuver-print-checkbox')
        @toggle_expanded_shield_hull_container = $ @list_modal.find('.expanded-shield-hull-print-checkbox')
        @toggle_qrcode_container = $ @list_modal.find('.qrcode-checkbox')
        @toggle_obstacle_container = $ @list_modal.find('.obstacles-checkbox')
        @btn_print_list = ($ @list_modal.find('.print-list'))[0]
        @btn_copy_url = $ @list_modal.find('.copy-url')

        @btn_copy_url.click (e) =>
            @success =  window.navigator.clipboard.writeText(window.location.href);
            @self = $(e.currentTarget)
            if @success
                @self.addClass 'btn-success'
                setTimeout ( =>
                    @self.removeClass 'btn-success'
                ), 1000
        
        # the url copy button is only needed if the browser is hiding the address bar. This is the case for PWA links. 
        @btn_copy_url.hide() unless ["fullscreen", "standalone", "minimal-ui"].some((displayMode) => window.matchMedia('(display-mode: ' + displayMode + ')').matches)

        @list_modal.on 'click', 'button.btn-copy', (e) =>
            @self = $(e.currentTarget)
            @self.siblings('textarea').select()
            @success = document.execCommand('copy')
            if @success
                @self.addClass 'btn-success'
                setTimeout ( =>
                    @self.removeClass 'btn-success'
                ), 1000

        @select_simple_view_button = $ @list_modal.find('.select-simple-view')
        @select_simple_view_button.click (e) =>
            @select_simple_view_button.blur()
            unless @list_display_mode == 'simple'
                @list_modal.find('.list-display-mode .btn').removeClass 'btn-inverse'
                @select_simple_view_button.addClass 'btn-inverse'
                @list_display_mode = 'simple'
                @simple_container.show()
                @fancy_container.hide()
                @simplecopy_container.hide()
                @reddit_container.hide()
                @tts_container.hide()
                @xws_container.hide()
                @toggle_vertical_space_container.hide()
                @toggle_color_print_container.hide()
                @toggle_color_skip_text.hide()
                @toggle_maneuver_dial_container.hide()
                @toggle_expanded_shield_hull_container.hide()
                @toggle_qrcode_container.show()
                @toggle_obstacle_container.show()
                @btn_print_list.disabled = false;

        @select_fancy_view_button = $ @list_modal.find('.select-fancy-view')
        @select_fancy_view_button.click (e) =>
            @select_fancy_view_button.blur()
            unless @list_display_mode == 'fancy'
                @list_modal.find('.list-display-mode .btn').removeClass 'btn-inverse'
                @select_fancy_view_button.addClass 'btn-inverse'
                @list_display_mode = 'fancy'
                @fancy_container.show()
                @simple_container.hide()
                @simplecopy_container.hide()
                @reddit_container.hide()
                @tts_container.hide()
                @xws_container.hide()
                @toggle_vertical_space_container.show()
                @toggle_color_print_container.show()
                @toggle_color_skip_text.show()
                @toggle_maneuver_dial_container.show()
                @toggle_expanded_shield_hull_container.show()
                @toggle_qrcode_container.show()
                @toggle_obstacle_container.show()
                @btn_print_list.disabled = false;
                
        @select_reddit_view_button = $ @list_modal.find('.select-reddit-view')
        @select_reddit_view_button.click (e) =>
            @select_reddit_view_button.blur()
            unless @list_display_mode == 'reddit'
                @list_modal.find('.list-display-mode .btn').removeClass 'btn-inverse'
                @select_reddit_view_button.addClass 'btn-inverse'
                @list_display_mode = 'reddit'
                @reddit_container.show()
                @simplecopy_container.hide()
                @tts_container.hide()
                @xws_container.hide()
                @simple_container.hide()
                @fancy_container.hide()
                @reddit_textarea.select()
                @reddit_textarea.focus()
                @toggle_vertical_space_container.hide()
                @toggle_color_print_container.hide()
                @toggle_color_skip_text.hide()
                @toggle_maneuver_dial_container.hide()
                @toggle_expanded_shield_hull_container.hide()
                @toggle_qrcode_container.hide()
                @toggle_obstacle_container.hide()
                @btn_print_list.disabled = true;

        @select_simplecopy_view_button = $ @list_modal.find('.select-simplecopy-view')
        @select_simplecopy_view_button.click (e) =>
            @select_simplecopy_view_button.blur()
            unless @list_display_mode == 'simplecopy'
                @list_modal.find('.list-display-mode .btn').removeClass 'btn-inverse'
                @select_simplecopy_view_button.addClass 'btn-inverse'
                @list_display_mode = 'simplecopy'
                @reddit_container.hide()
                @simplecopy_container.show()
                @tts_container.hide()
                @xws_container.hide()
                @simple_container.hide()
                @fancy_container.hide()
                @simplecopy_textarea.select()
                @simplecopy_textarea.focus()
                @toggle_vertical_space_container.hide()
                @toggle_color_print_container.hide()
                @toggle_color_skip_text.hide()
                @toggle_maneuver_dial_container.hide()
                @toggle_expanded_shield_hull_container.hide()
                @toggle_qrcode_container.hide()
                @toggle_obstacle_container.hide()
                @btn_print_list.disabled = true;
                
                
        @select_tts_view_button = $ @list_modal.find('.select-tts-view')
        @select_tts_view_button.click (e) =>
            @select_tts_view_button.blur()
            unless @list_display_mode == 'tts'
                @list_modal.find('.list-display-mode .btn').removeClass 'btn-inverse'
                @select_tts_view_button.addClass 'btn-inverse'
                @list_display_mode = 'tts'
                @tts_container.show()
                @xws_container.hide()
                @simple_container.hide()
                @simplecopy_container.hide()
                @reddit_container.hide()
                @fancy_container.hide()
                @tts_textarea.select()
                @tts_textarea.focus()
                @toggle_vertical_space_container.hide()
                @toggle_color_print_container.hide()
                @toggle_color_skip_text.hide()
                @toggle_maneuver_dial_container.hide()
                @toggle_expanded_shield_hull_container.hide()
                @toggle_qrcode_container.hide()
                @toggle_obstacle_container.hide()
                @btn_print_list.disabled = true;


        @select_xws_view_button = $ @list_modal.find('.select-xws-view')
        @select_xws_view_button.click (e) =>
            @select_xws_view()

        if $(window).width() >= 768
            @simple_container.hide()
            @select_fancy_view_button.click()
        else
            @select_simple_view_button.click()

        @clear_squad_button = $ @status_container.find('.clear-squad')
        @clear_squad_button.click (e) =>
            if @current_squad.dirty and @backend?
                @backend.warnUnsaved this, () =>
                    @newSquadFromScratch()
            else
                @newSquadFromScratch()

        @show_points_destroyed_button = $ @status_container.find('.show-points-destroyed')
        @show_points_destroyed_button_span = $ @status_container.find('.show-points-destroyed-span')
        @show_points_destroyed_button.click (e) =>
            @show_points_destroyed = not @show_points_destroyed
            if @show_points_destroyed == false
                @points_destroyed_span.hide()
            else
                @points_destroyed_span.show()
            for ship in @ships
                if ship.pilot?
                    if @show_points_destroyed == false
                        @show_points_destroyed_button_span.text @uitranslation("Show Points Destroyed")
                        ship.points_destroyed_button.hide()
                    else
                        @show_points_destroyed_button_span.text @uitranslation("Hide Points Destroyed")
                        ship.points_destroyed_button.show()

        @squad_name_container = $ @status_container.find('div.squad-name-container')
        @squad_name_display = $ @container.find('.display-name')
        @squad_name_placeholder = $ @container.find('.squad-name')
        @squad_name_input = $ @squad_name_container.find('input')
        @squad_name_save_button = $ @squad_name_container.find('button.save')
        @squad_name_input.closest('div').hide()
        @points_container = $ @status_container.find('div.points-display-container')
        @total_points_span = $ @points_container.find('.total-points')
        @game_type_selector = $ @status_container.find('.game-type-selector')
        @game_type_selector.select2
            minimumResultsForSearch: -1
        @game_type_selector.change (e) =>
            # $(window).trigger 'xwing:gameTypeChanged', @game_type_selector.val()
            @onGameTypeChanged @game_type_selector.val()
        @desired_points_input = $ @points_container.find('.desired-points')
        @desired_points_input.change (e) =>
            @container.trigger 'xwing:pointsUpdated'
        @points_remaining_span = $ @points_container.find('.points-remaining')
        @points_destroyed_span = $ @points_container.find('.points-destroyed')
        @points_remaining_container = $ @points_container.find('.points-remaining-container')
        @unreleased_content_used_container = $ @points_container.find('.unreleased-content-used')
        @loading_failed_container = $ @points_container.find('.loading-failed-container')
        @old_version_container = $ @points_container.find('.old-version-container')
        @ship_number_invalid_container = $ @points_container.find('.ship-number-invalid-container')
        @multi_faction_warning_container = $ @points_container.find('.multi-faction-warning-container')
        @epic_not_legal_container = $ @points_container.find('.epic-not-legal-container')
        @collection_invalid_container = $ @points_container.find('.collection-invalid')
        @view_list_button = $ @status_container.find('div.button-container button.view-as-text')
        @randomize_button = $ @status_container.find('div.button-container button.randomize')
        @customize_randomizer = $ @status_container.find('div.button-container a.randomize-options')
        @misc_settings = $ @status_container.find('div.button-container a.misc-settings')
        @backend_status = $ @status_container.find('.backend-status')
        @backend_status.hide()

        @collection_button = $ @status_container.find('div.button-container a.collection')
        @collection_button.click (e) =>
            e.preventDefault()
            unless @collection_button.prop('disabled')
                @collection.modal.modal 'show'

        @squad_name_input.keypress (e) =>
            if e.which == 13
                @squad_name_save_button.click()
                false

        @squad_name_input.change (e) =>
            @backend_status.fadeOut 'slow'

        @squad_name_input.blur (e) =>
            @squad_name_input.change()
            @squad_name_save_button.click()

        @squad_name_display.click (e) =>
            e.preventDefault()
            @squad_name_display.hide()
            @squad_name_input.val $.trim(@current_squad.name)
            # Because Firefox handles this badly
            window.setTimeout () =>
                @squad_name_input.focus()
                @squad_name_input.select()
            , 100
            @squad_name_input.closest('div').show()
        @squad_name_save_button.click (e) =>
            e.preventDefault()
            @current_squad.dirty = true
            @container.trigger 'xwing-backend:squadDirtinessChanged'
            name = @current_squad.name = $.trim(@squad_name_input.val())
            if name.length > 0
                @squad_name_display.show()
                @container.trigger 'xwing-backend:squadNameChanged'
                @squad_name_input.closest('div').hide()

        @randomizer_options_modal = $ document.createElement('DIV')
        @randomizer_options_modal.addClass 'modal fade randomizer-modal'
        @randomizer_options_modal.tabindex = "-1"
        @randomizer_options_modal.role = "dialog"
        $('body').append @randomizer_options_modal
        @randomizer_options_modal.append $.trim """
            <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="translated" defaultText="Random Squad Builder Options"></h3>
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <label>
                                <span class="translated" defaultText="Maximum Ship Count"></span>
                                <input type="number" class="randomizer-ship-limit" value="#{DEFAULT_RANDOMIZER_SHIP_LIMIT}" placeholder="#{DEFAULT_RANDOMIZER_SHIP_LIMIT}" />
                            </label><br />
                            <label>
                                <input type="checkbox" class="randomizer-collection-only" checked="checked"/> 
                                <span class="translated" defaultText="Limit to collection"></span>
                            </label><br />
                            <label>
                                <span class="translated" defaultText="Sets and Expansions"></span>
                                <select class="randomizer-sources" multiple="1" data-placeholder='""" + @uitranslation('All sets and expansions') + """'>
                                </select>
                            </label><br />
                            <label>
                                <input type="checkbox" class="randomizer-fill-zero-pts" /> 
                                <span class="translated" defaultText="Always fill 0-point slots"></span>
                            </label><br />
                            <label>
                                <span class="translated" defaultText="Maximum Seconds to Spend Randomizing"></span>
                                <input type="number" class="randomizer-timeout" value="#{DEFAULT_RANDOMIZER_TIMEOUT_SEC}" placeholder="#{DEFAULT_RANDOMIZER_TIMEOUT_SEC}" />
                            </label>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-primary do-randomize translated" aria-hidden="true" defaultText="Roll!"></button>
                        <button class="btn translated" data-dismiss="modal" aria-hidden="true" defaultText="Close"></button>
                    </div>
                </div>
            </div>
        """
        # translate the UI we just created. 
        exportObj.translateUIElements(@randomizer_options_modal)
        
        @randomizer_source_selector = $ @randomizer_options_modal.find('select.randomizer-sources')
        for expansion in exportObj.expansions
            opt = $ document.createElement('OPTION')
            opt.text expansion
            @randomizer_source_selector.append opt
        @randomizer_source_selector.select2
            width: "100%"
            minimumResultsForSearch: if $.isMobile() then -1 else 0
        @randomizer_collection_selector = ($ @randomizer_options_modal.find('.randomizer-collection-only'))[0]
        @randomizer_fill_zero_pts = ($ @randomizer_options_modal.find('.randomizer-fill-zero-pts'))[0]

        @randomize_button.click (e) =>
            e.preventDefault()
            if @current_squad.dirty and @backend?
                @backend.warnUnsaved this, () =>
                    @randomize_button.click()
            else
                points = parseInt @desired_points_input.val()
                points = DEFAULT_RANDOMIZER_POINTS if (isNaN(points) or points <= 0)
                ship_limit = parseInt $(@randomizer_options_modal.find('.randomizer-ship-limit')).val()
                ship_limit = DEFAULT_RANDOMIZER_SHIP_LIMIT if (isNaN(ship_limit) or ship_limit < 0)
                timeout_sec = parseInt $(@randomizer_options_modal.find('.randomizer-timeout')).val()
                timeout_sec = DEFAULT_RANDOMIZER_TIMEOUT_SEC if (isNaN(timeout_sec) or timeout_sec <= 0)
                # console.log "points=#{points}, sources=#{@randomizer_source_selector.val()}, timeout=#{timeout_sec}"
                @randomSquad(points, @randomizer_source_selector.val(), timeout_sec * 1000, ship_limit, @randomizer_collection_selector.checked, @randomizer_fill_zero_pts.checked)

        @randomizer_options_modal.find('button.do-randomize').click (e) =>
            e.preventDefault()
            @randomizer_options_modal.modal('hide')
            @randomize_button.click()
            
        @customize_randomizer.click (e) =>
            e.preventDefault()
            @randomizer_options_modal.modal()

        @misc_settings_modal = $ document.createElement('DIV')
        @misc_settings_modal.addClass 'modal fade'
        @misc_settings_modal.tabindex = "-1"
        @misc_settings_modal.role = "dialog"
        $('body').append @misc_settings_modal
        @misc_settings_modal.append $.trim """
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="translated" defaultText="Miscellaneous Settings"></h3>
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            </div>
            <div class="modal-body">
                <label class = "toggle-initiative-prefix-names misc-settings-label">
                    <input type="checkbox" class="initiative-prefix-names-checkbox misc-settings-checkbox" /> <span class="translated" defaultText="Use INI prefix"></span> 
                </label><br />
                <label class = "enable-ban-list misc-settings-label">
                    <input type="checkbox" class="enable-ban-list-checkbox misc-settings-checkbox" /> <span class="translated" defaultText="Enable Ban List (Not Standard)"></span> 
                </label><br />
            </div>
            <div class="modal-footer">
                <span class="misc-settings-infoline"></span>
                &nbsp;
                <button class="btn translated" data-dismiss="modal" aria-hidden="true" defaultText="Close"></button>
            </div>
        </div>
    </div>
        """
        @misc_settings_infoline = $ @misc_settings_modal.find('.misc-settings-infoline')
        @misc_settings_initiative_prefix = $ @misc_settings_modal.find('.initiative-prefix-names-checkbox')
        @misc_settings_ban_list = $ @misc_settings_modal.find('.enable-ban-list-checkbox')
        if @backend? 
            @backend.getSettings (st) =>
                exportObj.settings ?= []
                exportObj.settings.initiative_prefix = st.showInitiativeInFrontOfPilotName?
                if st.showInitiativeInFrontOfPilotName? 
                    @misc_settings_initiative_prefix.prop('checked', true)

                exportObj.settings.ban_list = st.enableBanList?
                if st.enableBanList? 
                    @misc_settings_ban_list.prop('checked', true)
        else 
            @waiting_for_backend ?= []
            @waiting_for_backend.push => 
                @backend.getSettings (st) =>
                    exportObj.settings ?= []
                    exportObj.settings.initiative_prefix = st.showInitiativeInFrontOfPilotName?
                    if st.showInitiativeInFrontOfPilotName? 
                        @misc_settings_initiative_prefix.prop('checked', true)
                    exportObj.settings.ban_list = st.enableBanList?
                    if st.enableBanList? 
                        @misc_settings_ban_list.prop('checked', true)
                        
        @misc_settings_initiative_prefix.click (e) =>
            exportObj.settings ?= []
            exportObj.settings.initiative_prefix = @misc_settings_initiative_prefix.prop('checked')
            if @backend? 
                if @misc_settings_initiative_prefix.prop('checked')
                    @backend.set 'showInitiativeInFrontOfPilotName', '1', (ds) =>
                        @misc_settings_infoline.text @uitranslation("Changes Saved")
                        @misc_settings_infoline.fadeIn 100, =>
                            @misc_settings_infoline.fadeOut 3000
                else 
                    @backend.deleteSetting 'showInitiativeInFrontOfPilotName', (dd) =>
                        @misc_settings_infoline.text @uitranslation("Changes Saved")
                        @misc_settings_infoline.fadeIn 100, =>
                            @misc_settings_infoline.fadeOut 3000

        @misc_settings_ban_list.click (e) =>
            exportObj.settings ?= []
            exportObj.settings.ban_list = @misc_settings_ban_list.prop('checked')
            if @backend? 
                if @misc_settings_ban_list.prop('checked')
                    @backend.set 'enableBanList', '1', (ds) =>
                        @misc_settings_infoline.text @uitranslation("Changes Saved")
                        @misc_settings_infoline.fadeIn 100, =>
                            @misc_settings_infoline.fadeOut 3000
                else 
                    @backend.deleteSetting 'enableBanList', (dd) =>
                        @misc_settings_infoline.text @uitranslation("Changes Saved")
                        @misc_settings_infoline.fadeIn 100, =>
                            @misc_settings_infoline.fadeOut 3000


        @misc_settings.click (e) =>
            e.preventDefault()
            @misc_settings_modal.modal()
            @misc_settings_initiative_prefix.prop('checked', exportObj.settings?.initiative_prefix? and exportObj.settings.initiative_prefix)

        exportObj.translateUIElements(@misc_settings_modal) 

        @choose_obstacles_modal = $ document.createElement 'DIV'
        @choose_obstacles_modal.addClass 'modal fade choose-obstacles-modal'
        @choose_obstacles_modal.tabindex = "-1"
        @choose_obstacles_modal.role = "dialog"
        @container.append @choose_obstacles_modal
        @choose_obstacles_modal.append $.trim """
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <label class='choose-obstacles-description translated' defaultText="Choose obstacles dialog"></label>
            </div>
            <div class="modal-body row">
                <div class="obstacle-select-container col-md-12">
                </div>
                <div>
                    <div class="obstacle-sources-container">
                        <span class="info-header obstacle-sources translated" defaultText="Sources:" style="padding-left: 8px;"></span> <br>
                        <div class="info-data obstacle-sources" style="padding-left: 8px;padding-right:10px;"></div>
                    </div>
                </div>
            </div>
            <div class="modal-footer d-print-none">
                <button class="btn btn-danger reset-obstacles translated" defaultText="Reset Obstacles"></button>
                <button class="btn btn-danger close-print-dialog translated" data-dismiss="modal" aria-hidden="true" defaultText="Close"></button>
            </div>
        </div>
    </div>
        """
        @obstacles_reset = @choose_obstacles_modal.find('.reset-obstacles')
        @obstacles_select = @choose_obstacles_modal.find('.obstacle-select-container')
        @obstacles_select_sources = @choose_obstacles_modal.find('.info-data.obstacle-sources')

        obstacleFormat = (state) ->
            image_name = 'images/' + state.id + '.png'
            return "<img class='obstacle' src='#{image_name}' style='height: 100px;' /></br>" + state.text

        @obstacle_data = [
            {
                id: "coreasteroid0"
                text: "Core Asteroid 1"
            }
            {
                id: "coreasteroid1"
                text: "Core Asteroid 2"
            }
            {
                id: "coreasteroid2"
                text: "Core Asteroid 3"
            }
            {
                id: "coreasteroid3"
                text: "Core Asteroid 4"
            }
            {
                id: "coreasteroid4"
                text: "Core Asteroid 5"
            }
            {
                id: "coreasteroid5"
                text: "Core Asteroid 6"
            }
            {
                id: "yt2400debris0"
                text: "YT2400 Debris 1"
            }
            {
                id: "yt2400debris1"
                text: "YT2400 Debris 2"
            }
            {
                id: "yt2400debris2"
                text: "YT2400 Debris 3"
            }
            {
                id: "vt49decimatordebris0"
                text: "VT49 Debris 1"
            }
            {
                id: "vt49decimatordebris1"
                text: "VT49 Debris 2"
            }
            {
                id: "vt49decimatordebris2"
                text: "VT49 Debris 3"
            }
            {
                id: "core2asteroid0"
                text: "FA Asteroid 1"
            }
            {
                id: "core2asteroid1"
                text: "FA Asteroid 2"
            }
            {
                id: "core2asteroid2"
                text: "FA Asteroid 3"
            }
            {
                id: "core2asteroid3"
                text: "FA Asteroid 4"
            }
            {
                id: "core2asteroid4"
                text: "FA Asteroid 5"
            }
            {
                id: "core2asteroid5"
                text: "FA Asteroid 6"
            }
            {
                id: "gascloud1"
                text: "Gas Cloud 1"
            }
            {
                id: "gascloud2"
                text: "Gas Cloud 2"
            }
            {
                id: "gascloud3"
                text: "Gas Cloud 3"
            }
            {
                id: "gascloud4"
                text: "Gas Cloud 4"
            }
            {
                id: "gascloud5"
                text: "Gas Cloud 5"
            }
            {
                id: "gascloud6"
                text: "Gas Cloud 6"
            }
            {
                id: "pomasteroid1"
                text: "PoM Rock 1"
            }
            {
                id: "pomasteroid2"
                text: "PoM Rock 2"
            }
            {
                id: "pomasteroid3"
                text: "PoM Rock 3"
            }
            {
                id: "pomdebris1"
                text: "PoM Debris 1"
            }
            {
                id: "pomdebris2"
                text: "PoM Debris 2"
            }
            {
                id: "pomdebris3"
                text: "PoM Debris 3"
            }
        ]

        @obstacles_select.select2
            data: @obstacle_data
            width: '90%'
            multiple: true
            maximumSelectionSize: 3
            placeholder: "Select an Obstacle"
            minimumResultsForSearch: if $.isMobile() then -1 else 0
            formatResult: obstacleFormat
            formatSelection: obstacleFormat
        # Backend

        @obstacles_select.select2.minimumResultsForSearch = -1 if $.isMobile()
        @backend_list_squads_button = $ @container.find('button.backend-list-my-squads')
        @backend_list_squads_button.click (e) =>
            e.preventDefault()
            if @backend?
                @backend.list this
        @backend_save_list_button = $ @container.find('button.save-list')
        @backend_save_list_button.click (e) =>
            e.preventDefault()
            if @backend? and not @backend_save_list_button.hasClass('disabled')
                additional_data =
                    points: @total_points
                    description: @describeSquad()
                    cards: @listCards()
                    notes: @notes.val().substr(0, 1024)
                    obstacles: @getObstacles()
                    tag: @tag.val().substr(0, 1024)
                @backend_status.html $.trim """
                    <i class="fa fa-sync fa-spin"></i>&nbsp;<span class="translated" defaultText="Saving squad..."></span>
                """
                @backend_status.show()
                @backend_save_list_button.addClass 'disabled'
                await @backend.save @serialize(), @current_squad.id, @current_squad.name, @faction, additional_data, (results)=>
                    if results.success
                        @current_squad.dirty = false
                        if @current_squad.id?
                            @backend_status.html $.trim """
                                <i class="fa fa-check"></i>&nbsp;<span class="translated" defaultText="Squad updated successfully."></span>
                            """
                        else
                            @backend_status.html $.trim """
                                <i class="fa fa-check"></i>&nbsp;<span class="translated" defaultText="New squad saved successfully."></span>
                            """
                            @current_squad.id = results.id
                        @container.trigger 'xwing-backend:squadDirtinessChanged'
                    else
                        @backend_status.html $.trim """
                            <i class="fa fa-exclamation-circle"></i>&nbsp;#{results.error}
                        """
                        @backend_save_list_button.removeClass 'disabled'
        @backend_save_list_as_button = $ @container.find('button.save-list-as')
        @backend_save_list_as_button.addClass 'disabled'
        @backend_save_list_as_button.click (e) =>
            e.preventDefault()
            if @backend? and not @backend_save_list_as_button.hasClass('disabled')
                @backend.showSaveAsModal this
        @backend_delete_list_button = $ @container.find('button.delete-list')
        @backend_delete_list_button.click (e) =>
            e.preventDefault()
            if @backend? and not @backend_delete_list_button.hasClass('disabled')

                @backend.showDeleteModal this

        content_container = $ document.createElement 'DIV'
        content_container.addClass 'container-fluid'
        @container.append content_container
        content_container.append $.trim """
            <div class="row">
                <div class="col-md-9 ship-container">
                    <label class="unsortable notes-container show-authenticated col-md-10">
                        <span class="notes-name translated" defaultText="Squad Notes:"></span>
                        <br />
                        <textarea class="squad-notes"></textarea>
                        <br />
                        <span class="tag-name translated" defaultText="Tag:"></span>
                        <input type="search" class="squad-tag"></input>
                    </label>
                    <div class="unsortable obstacles-container">
                            <button class="btn btn-info choose-obstacles"><i class="fa fa-cloud"></i>&nbsp;<span class="translated" defaultText="Choose Obstacles"</span></button>
                    </div>
                </div>
                <div class="col-md-3 info-container" id="info-container">
                </div>
            </div>
        """

        @ship_container = $ content_container.find('div.ship-container')
        @info_container = $ content_container.find('div.info-container')
        @obstacles_container = content_container.find('.obstacles-container')
        @notes_container = $ content_container.find('.notes-container')
        @notes = $ @notes_container.find('textarea.squad-notes')
        @tag = $ @notes_container.find('input.squad-tag')

        @ship_container.sortable
            cancel: '.unsortable'

        @info_container.append $.trim @createInfoContainerUI()
        @info_container.find('.info-well').hide()
        @info_intro = @info_container.find('.intro')

        @print_list_button = $ @container.find('button.print-list')

        @container.find('[rel=tooltip]').tooltip()

        # obstacles
        @obstacles_button = $ @container.find('button.choose-obstacles')
        @obstacles_button.click (e) =>
            e.preventDefault()
            @showChooseObstaclesModal()

        # conditions
        @condition_container = $ document.createElement('div')
        @condition_container.addClass 'conditions-container d-flex flex-wrap'
        @container.append @condition_container

        @mobile_tooltip_modal = $ document.createElement 'DIV'
        @mobile_tooltip_modal.addClass 'modal fade choose-obstacles-modal d-print-none'
        @mobile_tooltip_modal.tabindex = "-1"
        @mobile_tooltip_modal.role = "dialog"
        @container.append @mobile_tooltip_modal
        @mobile_tooltip_modal.append $.trim """
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
        <div class="modal-content">
            <div class="modal-header">
            </div>
            <div class="modal-body">
                """ + @createInfoContainerUI(false) + """
            </div>
            <div class="modal-footer">
                <button class="btn btn-danger close-print-dialog translated" data-dismiss="modal" aria-hidden="true" defaultText="Close"></button>
            </div>
        </div>
    </div>
        """
        @mobile_tooltip_modal.find('intro').hide()

        # translate all the UI we just created to current language
        exportObj.translateUIElements(@container) 

    createInfoContainerUI: (include_intro = true) ->
        if include_intro == true
            intro = """
                <div class="card intro translated" defaultText="Intro Card YASB">
                </div>
            """
        else
            intro = ""

        return """
            #{intro}
            <div class="card info-well">
                <div class="info-name"></div>
                <div class="info-type"></div>
                <span class="info-collection"></span>
                <div class="row">
                    <div class="col-sm-5">
                        <table class="table-sm">
                            <tbody>
                                <tr class="info-attack-bullseye">
                                    <td class="info-header"><i class="xwing-miniatures-font header-attack xwing-miniatures-font-bullseyearc"></i></td>
                                    <td class="info-data info-attack"></td>
                                </tr>
                                <tr class="info-attack">
                                    <td class="info-header"><i class="xwing-miniatures-font header-attack xwing-miniatures-font-frontarc"></i></td>
                                    <td class="info-data info-attack"></td>
                                </tr>
                                <tr class="info-attack-fullfront">
                                    <td class="info-header"><i class="xwing-miniatures-font header-attack xwing-miniatures-font-fullfrontarc"></i></td>
                                    <td class="info-data info-attack"></td>
                                </tr>
                                <tr class="info-attack-left">
                                    <td class="info-header"><i class="xwing-miniatures-font header-attack xwing-miniatures-font-leftarc"></i></td>
                                    <td class="info-data info-attack"></td>
                                </tr>
                                <tr class="info-attack-right">
                                    <td class="info-header"><i class="xwing-miniatures-font header-attack xwing-miniatures-font-rightarc"></i></td>
                                    <td class="info-data info-attack"></td>
                                </tr>
                                <tr class="info-attack-back">
                                    <td class="info-header"><i class="xwing-miniatures-font header-attack xwing-miniatures-font-reararc"></i></td>
                                    <td class="info-data info-attack"></td>
                                </tr>
                                <tr class="info-attack-turret">
                                    <td class="info-header"><i class="xwing-miniatures-font header-attack xwing-miniatures-font-singleturretarc"></i></td>
                                    <td class="info-data info-attack"></td>
                                </tr>
                                <tr class="info-attack-doubleturret">
                                    <td class="info-header"><i class="xwing-miniatures-font header-attack xwing-miniatures-font-doubleturretarc"></i></td>
                                    <td class="info-data info-attack"></td>
                                </tr>
                                <tr class="info-agility">
                                    <td class="info-header"><i class="xwing-miniatures-font header-agility xwing-miniatures-font-agility"></i></td>
                                    <td class="info-data info-agility"></td>
                                </tr>
                                <tr class="info-hull">
                                    <td class="info-header"><i class="xwing-miniatures-font header-hull xwing-miniatures-font-hull"></i></td>
                                    <td class="info-data info-hull"></td>
                                </tr>
                                <tr class="info-shields">
                                    <td class="info-header"><i class="xwing-miniatures-font header-shield xwing-miniatures-font-shield"></i></td>
                                    <td class="info-data info-shields"></td>
                                </tr>
                                <tr class="info-force">
                                    <td class="info-header"><i class="xwing-miniatures-font header-force xwing-miniatures-font-forcecharge"></i></td>
                                    <td class="info-data info-force"></td>
                                </tr>
                                <tr class="info-charge">
                                    <td class="info-header"><i class="xwing-miniatures-font header-charge xwing-miniatures-font-charge"></i></td>
                                    <td class="info-data info-charge"></td>
                                </tr>
                                <tr class="info-energy">
                                    <td class="info-header"><i class="xwing-miniatures-font header-energy xwing-miniatures-font-energy"></i></td>
                                    <td class="info-data info-energy"></td>
                                </tr>
                                <tr class="info-range">
                                    <td class="info-header translated" defaultText="Range"></td>
                                    <td class="info-data info-range"></td><td class="info-rangebonus"><i class="xwing-miniatures-font red header-range xwing-miniatures-font-rangebonusindicator"></i></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="col-sm-7">
                        <table class="table-sm">
                            <tbody>
                                <tr class="info-skill">
                                    <td class="info-header translated" defaultText="Initiative"></td>
                                    <td class="info-data info-skill"></td>
                                </tr>
                                <tr class="info-engagement">
                                    <td class="info-header translated" defaultText="Engagement"></td>
                                    <td class="info-data info-engagement"></td>
                                </tr>
                                <tr class="info-faction">
                                    <td class="info-header translated" defaultText="Faction"></td>
                                    <td class="info-data"></td>
                                </tr>
                                <tr class="info-base">
                                    <td class="info-header translated" defaultText="Base"></td>
                                    <td class="info-data"></td> 
                                </tr>
                                <tr class="info-points">
                                    <td class="info-header translated" defaultText="Points"></td>
                                    <td class="info-data info-points"></td>
                                </tr>
                                <tr class="info-loadout">
                                    <td class="info-header translated" defaultText="Loadout"></td>
                                    <td class="info-data info-loadout"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <table class="table-sm">
                    <tbody>
                        <tr class="info-ship">
                            <td class="info-header translated" defaultText="Ship"></td>
                            <td class="info-data"></td>
                        </tr>
                        <tr class="info-actions">
                            <td class="info-header translated" defaultText="Actions"></td>
                            <td class="info-data"></td>
                        </tr>
                        <tr class="info-upgrades">
                            <td class="info-header translated" defaultText="Upgrades"></td>
                            <td class="info-data"></td>
                        </tr>
                    </tbody>
                </table>
                <p class="info-restrictions"></p>
                <p class="info-text"></p>
                <p class="info-chassis"></p>
                <p class="info-maneuvers"></p>
                <br />
                <span class="info-header info-sources translated" defaultText="Sources:"></span> 
                <span class="info-data info-sources"></span>
            </div>
        """

    setupEventHandlers: ->
        @container.on 'xwing:claimUnique', (e, unique, type, cb) =>
            @claimUnique unique, type, cb
        .on 'xwing:releaseUnique', (e, unique, type, cb) =>
            @releaseUnique unique, type, cb
        .on 'xwing:pointsUpdated', (e, cb=$.noop) =>
            if @isUpdatingPoints
                cb()
            else
                @isUpdatingPoints = true
                @onPointsUpdated () =>
                    @isUpdatingPoints = false
                    cb()
        .on 'xwing-backend:squadLoadRequested', (e, squad, cb=$.noop) =>
            @onSquadLoadRequested squad, cb
        .on 'xwing-backend:squadDirtinessChanged', (e) =>
            @onSquadDirtinessChanged()
        .on 'xwing-backend:squadNameChanged', (e) =>
            @onSquadNameChanged()
        .on 'xwing:beforeLanguageLoad', (e, cb=$.noop) =>
            @pretranslation_serialized = @serialize()
            cb()
        .on 'xwing:afterLanguageLoad', (e, language, cb=$.noop) =>
            if @language != language
                @language = language
                old_dirty = @current_squad.dirty
                if @pretranslation_serialized.length?
                    @loadFromSerialized @pretranslation_serialized
                for ship in @ships
                    ship.updateSelections()
                @current_squad.dirty = old_dirty
                @pretranslation_serialized = undefined
            cb()
        # Recently moved this here.  Did this ever work?
        .on 'xwing:shipUpdated', (e, cb=$.noop) =>
            all_allocated = true
            for ship in @ships
                ship.updateSelections()
                if ship.ship_selector.val() == ''
                    all_allocated = false
            #console.log "all_allocated is #{all_allocated}, suppress_automatic_new_ship is #{@suppress_automatic_new_ship}"
            #console.log "should we add ship: #{all_allocated and not @suppress_automatic_new_ship}"
            @addShip() if all_allocated and not @suppress_automatic_new_ship

        $(window).on 'xwing-backend:authenticationChanged', (e) =>
            @resetCurrentSquad()
        .on 'xwing-collection:created', (e, collection) =>
            # console.log "#{@faction}: collection was created"
            @collection = collection
            # console.log "#{@faction}: Collection created, checking squad"
            # @collection.onLanguageChange null, @language
            @checkCollection()
            @collection_button.removeClass 'd-none'
        .on 'xwing-collection:changed', (e, collection) =>
            # console.log "#{@faction}: Collection changed, checking squad"
            @checkCollection()
        .on 'xwing-collection:destroyed', (e, collection) =>
            @collection = null
            @collection_button.addClass 'd-none'
        .on 'xwing:pingActiveBuilder', (e, cb) =>
            cb(this) if @container.is(':visible')
        .on 'xwing:activateBuilder', (e, faction, cb) =>
            if faction == @faction
                @tab.tab('show')
                cb this
        .on 'xwing:gameTypeChanged', (e, gameType, cb=$.noop) =>
            @onGameTypeChanged gameType, cb
            if @game_type_selector.val() != gameType
                @game_type_selector.val(gameType).trigger('change')

        @ship_container.on 'sortstart', (e, ui) =>
            @oldIndex = ui.item.index()
        .on 'sortstop', (e, ui) =>
            @updateShipOrder(@oldIndex, ui.item.index())

        @obstacles_reset.click (e) =>
            if @current_obstacles != []
                @current_obstacles = []
                @obstacles_select.select2('data', null)
                @current_squad.additional_data.obstacles = @current_obstacles
                @current_squad.dirty = true
                @container.trigger 'xwing-backend:squadDirtinessChanged'
                @container.trigger 'xwing:pointsUpdated'        

        @obstacles_select.change (e) =>
            @current_obstacles = @obstacles_select.val().split(',')
            @current_squad.additional_data.obstacles = @current_obstacles
            @current_squad.dirty = true
            @showObstaclesSelectInfo()
            @container.trigger 'xwing-backend:squadDirtinessChanged'
            @container.trigger 'xwing:pointsUpdated'

        @view_list_button.click (e) =>
            e.preventDefault()
            @showTextListModal()

        #Print Button
        @print_list_button.click (e) =>
            e.preventDefault()
            # Copy text list to printable
            @printable_container.find('.printable-header').html @list_modal.find('.modal-header').html()
            @printable_container.find('.printable-body').text ''
            switch @list_display_mode
                when 'simple'
                    @printable_container.find('.printable-body').html @simple_container.html()
                else
                    for ship in @ships
                        @printable_container.find('.printable-body').append ship.toHTML() if ship.pilot?
                    if @list_modal.find('.toggle-horizontal-space').prop('checked')then @printable_container.find('.upgrade-container').addClass('wide')
                    @printable_container.find('.printable-body').toggleClass 'bw', not @list_modal.find('.toggle-color-print').prop('checked')
                    if @list_modal.find('.toggle-skip-text-print').prop('checked')
                        for text in @printable_container.find('.upgrade-text, .fancy-pilot-text')
                            text.hidden = true
                    if @list_modal.find('.toggle-maneuver-print').prop('checked')
                        @printable_container.find('.printable-body').append @getSquadDialsAsHTML()
                    expanded_hull_and_shield = @list_modal.find('.toggle-expanded-shield-hull-print').prop('checked')
                    for container in @printable_container.find('.expanded-hull-or-shield')
                        container.hidden = not expanded_hull_and_shield
                    for container in @printable_container.find('.simple-hull-or-shield')
                        container.hidden = expanded_hull_and_shield

                    faction = switch @faction
                        when 'Rebel Alliance'
                            'rebel'
                        when 'Galactic Empire'
                            'empire'
                        when 'Scum and Villainy'
                            'scum'
                        when 'Resistance'
                            'rebel-outline'
                        when 'First Order'
                            'firstorder'
                        when 'Galactic Republic'
                            'republic'
                        when 'Separatist Alliance'
                            'separatists'
                        when 'All'
                            'first-player-4'

                    if @list_modal.find('.toggle-color-print').prop('checked')then @printable_container.find('.fancy-header').addClass(faction)
                    if @list_modal.find('.toggle-color-print').prop('checked')then @printable_container.find('.fancy-pilot-header').addClass("#{faction}-pilot")

                    @printable_container.find('.squad-faction').html """<i class="xwing-miniatures-font xwing-miniatures-font-#{faction}"></i>"""
            # List type
            if @isStandard
                @printable_container.find('.squad-name').append """ <i class="xwing-miniatures-font xwing-miniatures-font-first-player-1"></i>"""
            if @isEpic
                @printable_container.find('.squad-name').append """ <i class="xwing-miniatures-font xwing-miniatures-font-energy"></i>""" 
            if @isXwa
                @printable_container.find('.squad-name').append """ <i class="xwing-miniatures-font xwing-miniatures-font-point"></i>""" 

            versioninfo = "09/06/2024"
            rules = "AMG"
            if @isXwa
                versioninfo = "R2"
                rules = "XWA"

            # Version number
            @printable_container.find('.fancy-under-header').append $.trim """
                <div class="version">Points Version: #{rules} - #{versioninfo}</div>
            """
                    
            # Notes, if present
            if $.trim(@notes.val()) != ''
                @printable_container.find('.printable-body').append $.trim """
                    <h5 class="print-notes translated" defaultText="Notes:"></h5>
                    <pre class="print-notes"></pre>
                """            
                @printable_container.find('.printable-body pre.print-notes').text @notes.val()
            else

            # Conditions
            @printable_container.find('.printable-body').append $.trim """
                <div class="print-conditions"></div>
            """
            @printable_container.find('.printable-body .print-conditions').html @condition_container.html()

            # Obstacles
            if @list_modal.find('.toggle-obstacles').prop('checked')
                obstacles = @getObstacles()
                obstaclelist = ""
                for obstaclename in obstacles
                    obstaclelist += """<img class="obstacle-silhouettes" src="images/#{obstaclename}.png" />"""

                @printable_container.find('.printable-body').append $.trim """
                    <div class="obstacles">
                        <div>Chosen Obstacles:<br>#{obstaclelist}</div>
                    </div>
                """

            # Add QR code
            query = @getPermaLinkParams(['sn', 'obs'])
            if query? and @list_modal.find('.toggle-juggler-qrcode').prop('checked')
                @printable_container.find('.printable-body').append $.trim """
                <div class="qrcode-container">
                    <div class="permalink-container">
                        <div class="qrcode">YASB Link</div>
                        <div class="qrcode-text translated" defaultText="Scan QR-Code"></div>
                    </div>
                    <div class="xws-container">
                        <div class="qrcode">XWS Data</div>
                        <div class="qrcode-text translated" defaultText="XWS QR-Code"></div>
                    </div>
                </div>
                """
                text = JSON.stringify(@toXWS())
                console.log "#{text}"
                @printable_container.find('.xws-container .qrcode').qrcode
                    render: 'div'
                    ec: 'M'
                    size: if text.length < 144 then 144 else 256
                    text: text
                text = "https://yasb.app/#{query}"
                @printable_container.find('.permalink-container .qrcode').qrcode
                    render: 'div'
                    ec: 'M'
                    size: if text.length < 144 then 144 else 256
                    text: text

            #Trigger List
            triggertext = "while you perform"
            sectiontext = ""
            for ship in @ships
                if (ship.pilot?.text?) and (ship.pilot.text.match(triggertext) > -1)
                    sectiontext = sectiontext + "#{ship.pilot.name} <br><br>"
                for upgrade in ship.upgrades
                    if (upgrade.text?) and (upgrade.text.match(triggertext) > -1)
                        sectiontext = sectiontext + "#{upgrade.name} <br><br>"

            window.print()

        $(window).resize =>
            @select_simple_view_button.click() if $(window).width() < 768 and @list_display_mode != 'simple'
            for ship in @ships
                ship.checkPilotSelectorQueryModal()



         @notes.change @onNotesUpdated
                
         @tag.change @onNotesUpdated

         @notes.on 'keyup', @onNotesUpdated
         @tag.on 'keyup', @onNotesUpdated

    getPermaLinkParams: (ignored_params=[]) =>
        params = {}
        params.f = encodeURI(@faction) unless 'f' in ignored_params
        params.d = encodeURI(@serialize()) unless 'd' in ignored_params
        params.sn = encodeURIComponent(@current_squad.name) unless 'sn' in ignored_params
        params.obs = encodeURI(@current_squad.additional_data.obstacles || '') unless 'obs' in ignored_params
        return "?" + ("#{k}=#{v}" for k, v of params).join("&")

    getPermaLink: (params=@getPermaLinkParams()) => "#{URL_BASE}#{params}"

    updateShipOrder: (oldpos, newpos) =>
        selectedShip = @ships[oldpos]
        @ships.splice(oldpos, 1)
        @ships.splice(newpos, 0, selectedShip)
        @updatePermaLink
        if oldpos != newpos
            @current_squad.dirty = true
            @container.trigger 'xwing-backend:squadDirtinessChanged'

    updatePermaLink: () =>
        return unless @container.is(':visible') # gross but couldn't make clearInterval work
        next_params = @getPermaLinkParams()
        if window.location.search != next_params
          window.history.replaceState(next_params, '', @getPermaLink(next_params))

    onNotesUpdated: =>
        if @total_points > 0
            @current_squad.dirty = true
            @container.trigger 'xwing-backend:squadDirtinessChanged'

    onGameTypeChanged: (gametype, cb=$.noop) =>
        oldQuickbuild = @isQuickbuild
        @isStandard = false
        @isXwa = false
        @isEpic = false
        @isQuickbuild = false
        @epic_not_legal_container.toggleClass 'd-none', true
        switch gametype
            when 'xwa'
                @isXwa = true
                @desired_points_input.val 20
            when 'extended'
                @desired_points_input.val 20
            when 'epic'
                @isEpic = true
                @isXwa = true
                @desired_points_input.val 20
                @epic_not_legal_container.toggleClass 'd-none', false
            when 'quickbuild'
                @isQuickbuild = true
                @desired_points_input.val 8
            else
                @isStandard = true
                @desired_points_input.val 20
        if oldQuickbuild != @isQuickbuild
            old_id = @current_squad.id
            @newSquadFromScratch($.trim(@current_squad.name))
            @current_squad.id = old_id # we want to keep the ID, so we allow people to use the save button
        else
            old_id = @current_squad.id
            for ship in @ships
                if ship.pilot?
                    ship.setPilotById ship.pilot?.id
            @container.trigger 'xwing:pointsUpdated', $.noop
            @container.trigger 'xwing:shipUpdated'
        cb()

    addStandardizedToList: (ship) ->
        ship.addStandardizedUpgrades()

    onPointsUpdated: (cb=$.noop) =>
        tot_points = 0
        points_dest = 0
        unreleased_content_used = false
        # validating may remove the ship, if not only some upgrade, but the pilot himself is not valid. Thus iterate backwards over the array, so that is probably fine?
        
        for i in [@ships.length - 1 ... -1]
            ship = @ships[i]
            ship.validate()
            continue unless ship # if the ship has been removed, we no longer care about it
            # Standardized Loop, will integrate later for efficiency
            @addStandardizedToList(ship)

            tot_points += ship.getPoints()
            if ship.destroystate == 1
                points_dest += Math.floor ship.getPoints() / 2
            else if ship.destroystate == 2
                points_dest += ship.getPoints()
            ship_uses_unreleased_content = ship.checkUnreleasedContent()
            unreleased_content_used = ship_uses_unreleased_content if ship_uses_unreleased_content


        @total_points = tot_points
        @points_destroyed = points_dest
        @total_points_span.text @total_points
        points_left = parseInt(@desired_points_input.val()) - @total_points
        points_destroyed = parseInt(@total_points)
        @points_remaining_span.text points_left
        @points_destroyed_span.html if points_dest != 0 then """<i class="xwing-miniatures-font xwing-miniatures-font-hit"></i>#{points_dest}""" else ""
        @points_remaining_container.toggleClass 'red', (points_left < 0)
        @unreleased_content_used_container.toggleClass 'd-none', not unreleased_content_used

        if @isStandard == false then gamemode = "(Extended)" else gamemode = "(Standard)"
        if @isXwa then gamemode = "(XWA)" 
        if @isEpic then gamemode = "(Epic)"
        @fancy_total_points_container.text """(#{@total_points}) #{gamemode}"""
        
        # update text list
        @updatePrintAndExportTexts()

        # console.log "#{@faction}: Squad updated, checking collection"
        @checkCollection()

        # update conditions used
        # this old version of phantomjs i'm using doesn't support Set
        if Set?
            conditions_set = new Set()
            for ship in @ships
                # shouldn't there be a set union
                ship.getConditions().forEach (condition) ->
                    conditions_set.add(condition)
            conditions = []
            conditions_set.forEach (condition) ->
                conditions.push(condition)
            conditions.sort (a, b) ->
                if a.name.canonicalize() < b.name.canonicalize()
                    -1
                else if b.name.canonicalize() > a.name.canonicalize()
                    1
                else
                    0
            @condition_container.text ''
            conditions.forEach (condition) =>
                @condition_container.append conditionToHTML(condition)

        cb @total_points


    onSquadLoadRequested: (squad, cb=$.noop) =>
        @current_squad = squad
        @backend_delete_list_button.removeClass 'disabled'
        @updateObstacleSelect(@current_squad.additional_data.obstacles)
        afterLoading = () =>
            @notes.val(squad.additional_data.notes ? '')
            @tag.val(squad.additional_data.tag ? '')
            @backend_status.fadeOut 'slow'
            @current_squad.dirty = false
            @container.trigger 'xwing-backend:squadNameChanged'
            @container.trigger 'xwing-backend:squadDirtinessChanged'
            cb()
        if squad.serialized?.length?
            @loadFromSerialized squad.serialized, afterLoading
        else:
            afterLoading()


    onSquadDirtinessChanged: () =>
        #@current_squad.name = $.trim(@squad_name_input.val())
        @backend_save_list_button.toggleClass 'disabled', not (@current_squad.dirty and @total_points > 0)
        @backend_save_list_as_button.toggleClass 'disabled', @total_points == 0
        @backend_delete_list_button.toggleClass 'disabled', not @current_squad.id?
        if @ships.length > 1
            $('meta[property="og:description"]').attr("content", @uitranslation("X-Wing Squadron by YASB: ") + @current_squad.name + ": " + @describeSquad())
        else
            $('meta[property="og:description"]').attr("content", @uitranslation("YASB advertisment"))
        


    onSquadNameChanged: () =>
        if @current_squad.name.length > SQUAD_DISPLAY_NAME_MAX_LENGTH
            short_name = "#{@current_squad.name.substr(0, SQUAD_DISPLAY_NAME_MAX_LENGTH)}&hellip;"
        else
            short_name = @current_squad.name
        @squad_name_placeholder.text ''
        @squad_name_placeholder.append short_name
        @squad_name_input.val @current_squad.name
        return unless $.getParameterByName('f') == @faction
        if @current_squad.name != @uitranslation("Unnamed Squadron") and @current_squad.name != @uitranslation("Unsaved Squadron")
            if (document.title != "YASB - " + @current_squad.name) 
                document.title = "YASB - " + @current_squad.name
        else
            document.title = "YASB"
        @updatePrintAndExportTexts()


    updatePrintAndExportTexts: () =>
        # update text list
        @fancy_container.text ''
        @simple_container.html '<table class="simple-table"></table>'
        simplecopy_ships = []
        reddit_ships = []
        tts_ships = []
        for ship in @ships
            if ship.pilot?
                @fancy_container.append ship.toHTML()
                
                #for dial in @fancy_container.find('.fancy-dial')
                    #dial.hidden = true

                @simple_container.find('table').append ship.toTableRow()
                simplecopy_ships.push ship.toSimpleCopy()
                reddit_ships.push ship.toRedditText()
                tts_ships.push ship.toTTSText()

        @reddit_container.find('textarea').val $.trim """#{reddit_ships.join "    \n"}    \n**#{@uitranslation('Total')}:** *#{@total_points}*    \n    \n[#{@uitranslation('View in YASB')}](#{@getPermaLink()})"""
        @simplecopy_container.find('textarea').val $.trim """#{simplecopy_ships.join ""}    \n#{@uitranslation('Total')}: #{@total_points}    \n    \n#{@uitranslation('View in YASB')}: #{@getPermaLink()}"""
        

        #Additional code to add obstacles to TTS
        obstacles = @getObstacles()
        if (obstacles? and obstacles.length > 0) and (tts_ships.length > 0)
            tts_ships[tts_ships.length - 1] = tts_ships[tts_ships.length - 1].slice(0, -2)
            tts_obstacles = ' |'
            for obstacle in obstacles
                if obstacle?
                    tts_obstacles +=  """ #{obstacle} /"""
            tts_obstacles = tts_obstacles.slice(0, -1)
            tts_ships.push tts_obstacles

        @tts_textarea.val $.trim """#{tts_ships.join ""}"""

        @xws_textarea.val $.trim JSON.stringify(@toXWS())
        $('#xws-qrcode-container').text ''
        $('#xws-qrcode-container').qrcode
            render: 'canvas'
            text: JSON.stringify(@toMinimalXWS())
            ec: 'L'
            size: 128
        

    removeAllShips: ->
        while @ships.length > 0
            @removeShip @ships[0]
        throw new Error(@uitranslation("Ships not emptied")) if @ships.length > 0

    showTextListModal: ->
        # Display print/text view modal
        @list_modal.modal 'show'

    showXWSModal: (xws) ->
        # Display xws view modal
        @select_xws_view()
        @showTextListModal()

    showChooseObstaclesModal: ->
        @obstacles_select.select2('val', @current_squad.additional_data.obstacles)
        @choose_obstacles_modal.modal 'show'

    showObstaclesSelectInfo: ->
        obstacle_array = @obstacles_select.val().split(",")
        if obstacle_array != []
            newtext = ""
            for obstacle in obstacle_array
                sources = exportObj.obstacles[obstacle]?.sources ? []
                newtext += "<u>#{obstacle}</u>: #{(if (sources.length > 1) or (not (exportObj.translate('sources', 'Loose Ships') in sources)) then (if sources.length > 0 then sources.join(', ') else exportObj.translate('ui', 'unreleased')) else @uitranslation("Only available from 1st edition"))}</br>"
            @obstacles_select_sources.html $.trim newtext
        else
            @obstacles_select_sources.html ''

    updateObstacleSelect: (obstacles) ->
        @current_obstacles = obstacles ? []
        @obstacles_select.select2('val', obstacles)
        @showObstaclesSelectInfo()

    serialize: ->
        serialization_version = 9
        game_type_abbrev = switch @game_type_selector.val()
            when 'standard'
                'h'
            when 'extended'
                's'
            when 'xwa'
                'b'
            when 'epic'
                'e'
            when 'quickbuild'
                'q'
        selected_points = $.trim @desired_points_input.val()
        """v#{serialization_version}Z#{game_type_abbrev}Z#{selected_points}Z#{( ship.toSerialized() for ship in @ships when ship.pilot? and (not @isQuickbuild or ship.primary) ).join 'Y'}"""

    changeGameTypeOnSquadLoad: (gametype) ->
        if @game_type_selector.val() != gametype
            $(window).trigger 'xwing:gameTypeChanged', gametype


    loadFromSerialized: (serialized, cb=$.noop) ->
        @suppress_automatic_new_ship = true
        # Clear all existing ships
        @removeAllShips()

        re = if "Z" in serialized then /^v(\d+)Z(.*)/ else /^v(\d+)!(.*)/
        matches = re.exec serialized
        if matches?
            # versioned
            version = parseInt matches[1]
            # v9: X-Wing 2.5 points rework. Due to the massive change in points structure, previous versions will no longer be supported
            ship_splitter = if version > 7 then 'Y' else ';'
            # parse out game type
            [ game_type_abbrev, desired_points, serialized_ships ] =
                if version > 7
                     [g, p, s] = matches[2].split('Z')
                     [g, parseInt(p), s]
                else
                    [ game_type_and_point_abbrev, s ] = matches[2].split('!')
                    if parseInt(game_type_and_point_abbrev.split('=')[1])
                        p = parseInt(game_type_and_point_abbrev.split('=')[1])
                    else
                        p = 20
                    g = game_type_and_point_abbrev.split('=')[0]
                    [ g, p, s ]

            if version < 9 # old version are no longer supported
                @old_version_container.toggleClass 'd-none', false
                @suppress_automatic_new_ship = false
                @addShip()
                return
            if !serialized_ships? # something went wrong, we can't load that serialization
                @loading_failed_container.toggleClass 'd-none', false
                @suppress_automatic_new_ship = false
                @addShip()
                return
            @isCurrentlyLoadingSquad = true
            switch game_type_abbrev
                when 's'
                    @changeGameTypeOnSquadLoad 'extended'
                when 'h'
                    @changeGameTypeOnSquadLoad 'standard'
                when 'b'
                    @changeGameTypeOnSquadLoad 'xwa'
                when 'e'
                    @changeGameTypeOnSquadLoad 'epic'
                when 'q'
                    @changeGameTypeOnSquadLoad 'quickbuild'
            @desired_points_input.val desired_points
            @desired_points_input.change()
            ships_with_unmet_dependencies = []
            if serialized_ships.length?
                for serialized_ship in serialized_ships.split(ship_splitter)
                    unless serialized_ship == ''
                        new_ship = @addShip()
                        # try to create ship. fromSerialized returns false, if some upgrade have been skipped as they are not legal until now (e.g. 0-0-0 but vader is not yet in the squad)
                        # if not the entire ship is valid, we'll try again later - but keep the valid part added, so other ships may already see some upgrades
                        if (not await new_ship.fromSerialized version, serialized_ship) or not new_ship.pilot # also check, if the pilot has been set (the pilot himself was not invalid)
                            ships_with_unmet_dependencies.push [new_ship, serialized_ship]
                for ship in ships_with_unmet_dependencies
                    # 2nd attempt to load ships with unmet dependencies.
                    if not ship[0].pilot
                        # create ship, if the ship was so invalid, that it in fact decided to not exist
                        ship[0] = @addShip()
                    ship[0].fromSerialized version, ship[1]
            @isCurrentlyLoadingSquad = false

        @suppress_automatic_new_ship = false
        # Finally, the unassigned ship
        @addShip()
        
        @container.trigger 'xwing:pointsUpdated'
        cb()


    select_xws_view: () ->
        @select_xws_view_button.blur()
        unless @list_display_mode == 'xws'
            @list_modal.find('.list-display-mode .btn').removeClass 'btn-inverse'
            @select_xws_view_button.addClass 'btn-inverse'
            @list_display_mode = 'xws'
            @xws_container.show()
            @simple_container.hide()
            @simplecopy_container.hide()
            @reddit_container.hide()
            @fancy_container.hide()
            @tts_container.hide()
            @xws_textarea.select()
            @xws_textarea.focus()
            @toggle_vertical_space_container.hide()
            @toggle_color_print_container.hide()
            @toggle_color_skip_text.hide()
            @toggle_maneuver_dial_container.hide()
            @toggle_expanded_shield_hull_container.hide()
            @toggle_qrcode_container.hide()
            @toggle_obstacle_container.hide()
            @btn_print_list.disabled = true;


    uniqueIndex: (unique, type) ->
        if type not of @uniques_in_use
            throw new Error("Invalid unique type '#{type}'")
        @uniques_in_use[type].indexOf unique

    claimUnique: (unique, type, cb) =>
        if @uniqueIndex(unique, type) < 0
            # Claim pilots with the same canonical name
            for other in (exportObj.pilotsByUniqueName[unique.canonical_name.getXWSBaseName()] or [])
                if unique != other
                    if @uniqueIndex(other, 'Pilot') < 0
                        # console.log "Also claiming unique pilot #{other.canonical_name} in use"
                        @uniques_in_use['Pilot'].push other
                    else
                        throw new Error("Unique #{type} '#{unique.name}' already claimed as pilot")

            for other in (exportObj.upgradesByUniqueName[unique.canonical_name.getXWSBaseName()] or [])
                if @uniqueIndex(other, 'Upgrade') < 0
                    # console.log "Also claiming unique pilot #{other.canonical_name} in use"
                    @uniques_in_use['Upgrade'].push other
                else
                    throw new Error("Unique #{type} '#{other.name}' already claimed as pilot")

            # Solitary Check
            if unique.solitary?
                @uniques_in_use['Slot'].push unique.slot

            @uniques_in_use[type].push unique
        else
            throw new Error("Unique #{type} '#{unique.name}' already claimed")
        cb()

    releaseUnique: (unique, type, cb) =>
        idx = @uniqueIndex(unique, type)
        if idx >= 0
            # Release all uniques with the same canonical name and base name
            for type, uniques of @uniques_in_use
                # Removing stuff in a loop sucks, so we'll construct a new list
                if type == 'Slot'
                    if unique.solitary?
                        @uniques_in_use[type] = []
                        for u in uniques
                            if u != unique.slot
                                # Keep this one
                                @uniques_in_use[type].push u.slot
                else
                    @uniques_in_use[type] = []
                    for u in uniques
                        if u.canonical_name.getXWSBaseName() != unique.canonical_name.getXWSBaseName()
                            # Keep this one
                            @uniques_in_use[type].push u
                        # else
                        #     console.log "Releasing #{u.name} (#{type}) with canonical name #{unique.canonical_name}"
        else
            throw new Error("Unique #{type} '#{unique.name}' not in use")
        cb()

    addShip: ->
        new_ship = new Ship
            builder: this
            container: @ship_container
        @ships.push new_ship
        @ship_number_invalid_container.toggleClass 'd-none', (@ships.length < 10 and @ships.length > 3) # bounds are 2..10 as we always have a "empty" ship at the bottom
        @multi_faction_warning_container.toggleClass 'd-none', (@faction != "All")
        new_ship

    removeShip: (ship, cb=$.noop) ->
        if ship?.destroy?
            await new Promise((resolve,reject) => ship.destroy resolve)
            await new Promise((resolve,reject) => @container.trigger 'xwing:pointsUpdated', resolve)
            @current_squad.dirty = true
            @container.trigger 'xwing-backend:squadDirtinessChanged'
            @ship_number_invalid_container.toggleClass 'd-none', (@ships.length < 10 and @ships.length > 3)
            @multi_faction_warning_container.toggleClass 'd-none', (@faction != "All")
        cb()
    
    matcher: (item, term) ->
        item.toUpperCase().indexOf(term.toUpperCase()) >= 0

    isOurFaction: (faction, alt_faction = '') ->
        check_faction = @faction
        if @faction == "All"
            if alt_faction != ''
                check_faction = alt_faction
            else
                return true
        if faction instanceof Array
            for f in faction
                if getPrimaryFaction(f) == check_faction
                    return true
            false
        else
            getPrimaryFaction(faction) == check_faction

    isItemAvailable: (item_data, shipCheck=false) ->
        # this method is not even invoked by most quickbuild stuff to check availability for quickbuild squads, as the method was formerly just telling apart extended/standard
        if @isQuickbuild
            return true
        else if @isStandard
            return exportObj.standardCheck(item_data, @faction, shipCheck)
        else if (not @isEpic)
            if exportObj.settings?.ban_list? and exportObj.settings.ban_list
                if not exportObj.standardCheck(item_data, @faction, shipCheck, true) then return false
            return exportObj.epicExclusions(item_data)
        else
            if exportObj.settings?.ban_list? and exportObj.settings.ban_list
                if not exportObj.standardCheck(item_data, @faction, shipCheck, true) then return false
            return true

    getAvailableShipsMatching: (term='',sorted = true, collection_only = false) ->
        ships = []
        for ship_name, ship_data of exportObj.ships
            if @isOurFaction(ship_data.factions) and (@matcher(ship_data.name, term) or (ship_data.display_name and @matcher(ship_data.display_name, term)))
                if (@isItemAvailable(ship_data, true))
                    if (not collection_only or (@collection? and (@collection.checks.collectioncheck == "true") and @collection.checkShelf('ship', ship_data.name)))
                        ships.push
                            id: ship_data.name
                            text: if ship_data.display_name then ship_data.display_name else ship_data.name
                            chassis: ship_data.chassis
                            name: ship_data.name
                            display_name: ship_data.display_name
                            canonical_name: ship_data.canonical_name
                            xws: ship_data.name.canonicalize()
                            icon: if ship_data.icon then ship_data.icon else ship_data.name.canonicalize()
        if sorted
            ships.sort exportObj.sortHelper
        return ships

    getAvailableShipsMatchingAndCheapEnough: (points, term='', sorted=false, collection_only = false) ->
        # returns a list of ships that have at least one pilot cheaper than the given points value
        possible_ships = @getAvailableShipsMatching(term, sorted, collection_only)
        cheap_ships = []
        for ship in possible_ships
            pilots = @getAvailablePilotsForShipIncluding(ship.name, null, '', true)
            if pilots.length and pilots[0].points <= points
                cheap_ships.push(ship)
                
        return cheap_ships
        
    getAvailablePilotsForShipIncluding: (ship, include_pilot, term='', sorted = true, ship_selector = null) ->
        # Returns data formatted for Select2
        retval = []
        if not @isQuickbuild
            # select available pilots according to ususal pilot selection
            available_faction_pilots = (pilot for pilot_name, pilot of exportObj.pilots when (not ship? or pilot.ship == ship) and @isOurFaction(pilot.faction) and (@matcher(pilot_name, term) or (pilot.display_name and @matcher(pilot.display_name, term)) ) and (@isItemAvailable(pilot, true)))

            eligible_faction_pilots = (pilot for pilot_name, pilot of available_faction_pilots when (not pilot.unique? or pilot not in @uniques_in_use['Pilot'] or pilot.canonical_name.getXWSBaseName() == include_pilot?.canonical_name.getXWSBaseName()) and (not pilot.max_per_squad? or @countPilots(pilot.canonical_name) < pilot.max_per_squad or pilot.canonical_name.getXWSBaseName() == include_pilot?.canonical_name.getXWSBaseName()) and (not pilot.upgrades? or @standard_restriction_check(pilot, include_pilot)) and (not pilot.restriction_func? or pilot.restriction_func((builder: @) , pilot)))

            # Re-add selected pilot
            if include_pilot? and include_pilot.unique? and (@matcher(include_pilot.name, term) or (include_pilot.display_name and @matcher(include_pilot.display_name, term)) )
                eligible_faction_pilots.push include_pilot

            retval = ({ id: pilot.id, text: "#{if exportObj.settings?.initiative_prefix? and exportObj.settings.initiative_prefix then pilot.skill + ' - ' else ''}#{if pilot.display_name then pilot.display_name else pilot.name} (#{if (@isXwa and pilot.pointsxwa?) then pilot.pointsxwa else pilot.points}#{if pilot.loadout? then (if (@isXwa and pilot.loadoutxwa?) then "/#{pilot.loadoutxwa}" else "/#{pilot.loadout}") else ""})", points: (if (@isXwa and pilot.pointsxwa?) then pilot.pointsxwa else pilot.points), ship: pilot.ship, name: pilot.name, display_name: pilot.display_name, disabled: pilot not in eligible_faction_pilots } for pilot in available_faction_pilots)
        else
            # select according to quickbuild cards
            # filter for faction and ship
            quickbuilds_matching_ship_and_faction = (quickbuild for id, quickbuild of exportObj.quickbuildsById when (not ship? or quickbuild.ship == ship) and @isOurFaction(quickbuild.faction) and (@matcher(quickbuild.pilot, term) or (exportObj.pilots[quickbuild.pilot].display_name? and @matcher(exportObj.pilots[quickbuild.pilot].display_name, term)) ))

            # create a list of the uniques belonging to the currently selected pilot
            uniques_in_use_by_pilot_in_use = []
            if include_pilot? and include_pilot != -1
                include_quickbuild = exportObj.quickbuildsById[include_pilot]
                include_pilot_pilot = exportObj.pilots[include_quickbuild.pilot]
                if include_pilot_pilot.unique?
                    uniques_in_use_by_pilot_in_use.push include_pilot_pilot
                    for other in (exportObj.pilotsByUniqueName[include_pilot_pilot.canonical_name.getXWSBaseName()] or [])
                        if other?
                            uniques_in_use_by_pilot_in_use.push other
                for include_upgrade_name in include_quickbuild.upgrades ? []
                    include_upgrade = exportObj.upgrades[include_upgrade_name]
                    if include_upgrade.unique? 
                        uniques_in_use_by_pilot_in_use.push other
                        for other in (exportObj.pilotsByUniqueName[include_upgrade.canonical_name.getXWSBaseName()] or [])
                            if other? 
                                uniques_in_use_by_pilot_in_use.push other
                    if include_upgrade.solitary?
                        uniques_in_use_by_pilot_in_use.push include_upgrade.slot
                # we should also add upgrades with the same unique name like some selected upgrades or the pilot. However, finding them is teadious
                # we should also add uniques used by a linked ship. however, while it is easy to allow selecting them, it is harder to properly add them - as one need to make sure the order of selecting ship + linked ship matters

            # filter for uniques in use
            allowed_quickbuilds_containing_uniques_in_use = []
            loop: for id, quickbuild of quickbuilds_matching_ship_and_faction
                if exportObj.pilots[quickbuild.pilot]?.unique? and exportObj.pilots[quickbuild.pilot] in @uniques_in_use.Pilot and not (exportObj.pilots[quickbuild.pilot] in uniques_in_use_by_pilot_in_use)
                    allowed_quickbuilds_containing_uniques_in_use.push quickbuild.id
                    continue
                if exportObj.pilots[quickbuild.pilot]?.max_per_squad? and @countPilots(exportObj.pilots[quickbuild.pilot].canonical_name) >= exportObj.pilots[quickbuild.pilot].max_per_squad and not (exportObj.pilots[quickbuild.pilot] in uniques_in_use_by_pilot_in_use)
                    allowed_quickbuilds_containing_uniques_in_use.push quickbuild.id
                    continue
                if quickbuild.upgrades? 
                    for upgrade in quickbuild.upgrades
                        upgradedata = exportObj.upgrades[upgrade]
                        if not upgradedata?
                            console.log("There was an Issue including the upgrade " + upgrade + " in some quickbuild. Please report that Issue!")
                            continue
                        if upgradedata.unique? and upgradedata in @uniques_in_use.Upgrade and not (upgradedata in uniques_in_use_by_pilot_in_use)
                            # check, if unique is used by this ship or it's linked ship
                            if ship_selector == null or not (upgrade in exportObj.quickbuildsById[ship_selector.quickbuildId].upgrades or (ship_selector.linkedShip and upgrade in (exportObj.quickbuildsById[ship_selector.linkedShip?.quickbuildId].upgrades ? [])))
                                allowed_quickbuilds_containing_uniques_in_use.push quickbuild.id
                                break
                        # check if solitary type is already claimed
                        if upgradedata.solitary? and upgradedata.slot in @uniques_in_use['Slot'] and not (upgradedata.slot in uniques_in_use_by_pilot_in_use)
                            allowed_quickbuilds_containing_uniques_in_use.push quickbuild.id
                            break
            
            retval = ({id: quickbuild.id, text: "#{if exportObj.settings?.initiative_prefix? and exportObj.settings.initiative_prefix then exportObj.pilots[quickbuild.pilot].skill + ' - ' else ''}#{if exportObj.pilots[quickbuild.pilot].display_name then exportObj.pilots[quickbuild.pilot].display_name else quickbuild.pilot}#{quickbuild.suffix} (#{quickbuild.threat})", points: quickbuild.threat, ship: quickbuild.ship, disabled: quickbuild.id in allowed_quickbuilds_containing_uniques_in_use} for quickbuild in quickbuilds_matching_ship_and_faction)

        if sorted
            retval = retval.sort exportObj.sortHelper
        retval


    standard_restriction_check: (pilot, set_pilot) ->
        if pilot.upgrades?
            for upgrade in pilot.upgrades
                upgrade_data = exportObj.upgrades[upgrade]
                if upgrade_data.unique?
                    for ship in @ships
                        if not (ship.pilot?.name? and set_pilot?.name? and ship.pilot.name == set_pilot.name)
                            for shipupgrade in ship.upgrades
                                if shipupgrade?.data?.canonical_name == upgrade_data.canonical_name
                                    return false
        return true

    dfl_filter_func = ->
        true

    countUpgrades: (canonical_name) ->
        # returns number of upgrades with given canonical name equipped
        count = 0
        for ship in @ships
            if not ship.pilot?.upgrades?
                for upgrade in ship.upgrades
                    if upgrade?.data?.canonical_name == canonical_name
                        count++
        count

    countPilots: (canonical_name) ->
        # returns number of pilots with given canonical name
        count = 0
        for ship in @ships
            if ship?.pilot?.canonical_name.getXWSBaseName() == canonical_name.getXWSBaseName()
                count++
        count

    isShip: (ship, name) ->
        # console.log "returning #{f} #{name}"
        if ship instanceof Array
            for f in ship
                if f == name
                    return true
            false
        else
            ship == name

    getAvailableUpgradesIncluding: (slot, include_upgrade, ship, this_upgrade_obj, term='', filter_func=@dfl_filter_func, sorted=true) ->
        # Returns data formatted for Select2
        upgrades_in_use = (upgrade.data for upgrade in ship.upgrades)

        available_upgrades = (upgrade for upgrade_name, upgrade of exportObj.upgrades when exportObj.slotsMatching(upgrade.slot, slot) and ( @matcher(upgrade_name, term) or (upgrade.display_name and @matcher(upgrade.display_name, term)) ) and (not upgrade.ship? or @isShip(upgrade.ship, ship.data.name)) and (not upgrade.faction? or @isOurFaction(upgrade.faction, ship.pilot.faction)) and (@isItemAvailable(upgrade)) and (not upgrade.standard?))

        # available_upgrades = (upgrade for upgrade_name, upgrade of exportObj.upgrades when exportObj.slotsMatching(upgrade.slot, slot) and ( @matcher(upgrade_name, term) or (upgrade.display_name and @matcher(upgrade.display_name, term)) ) and (not upgrade.ship? or @isShip(upgrade.ship, ship.data.name)) and (not upgrade.faction? or ((@faction != "All") and @isOurFaction(upgrade.faction)) or ((@faction == "All") and (not ship.pilot? or (ship.pilot.faction == upgrade.faction)))) and (@isItemAvailable(upgrade)))

        if filter_func != @dfl_filter_func
            available_upgrades = (upgrade for upgrade in available_upgrades when filter_func(upgrade))

        points_without_include_upgrade = ship.upgrade_points_total - this_upgrade_obj.getPoints(include_upgrade)

        eligible_upgrades = (upgrade for upgrade_name, upgrade of available_upgrades when (upgrade not in @uniques_in_use['Upgrade']) and ship.standardized_check(upgrade) and ship.restriction_check((if (ship.builder.isXwa and upgrade.restrictionsxwa?) then upgrade.restrictionsxwa else (if upgrade.restrictions then upgrade.restrictions else undefined)),this_upgrade_obj, this_upgrade_obj.getPoints(upgrade), points_without_include_upgrade, upgrade) and upgrade not in upgrades_in_use and ((not upgrade.max_per_squad?) or ship.builder.countUpgrades(upgrade.canonical_name) < upgrade.max_per_squad) and (not upgrade.solitary? or (upgrade.slot not in @uniques_in_use['Slot'] or include_upgrade?.solitary?)))

        for equipped_upgrade in (upgrade.data for upgrade in ship.upgrades when upgrade?.data?)
            eligible_upgrades.removeItem equipped_upgrade

        # Re-enable selected upgrade
        if include_upgrade? and ((( @matcher(include_upgrade.name, term) or (include_upgrade.display_name and @matcher(include_upgrade.display_name, term)))))
            eligible_upgrades.push include_upgrade

        retval = ({ id: upgrade.id, text: "#{if upgrade.display_name then upgrade.display_name else upgrade.name} (#{this_upgrade_obj.getPoints(upgrade)}#{if upgrade.variablepoints then '*' else ''})", points: this_upgrade_obj.getPoints(upgrade), name: upgrade.name, display_name: upgrade.display_name, disabled: upgrade not in eligible_upgrades } for upgrade in available_upgrades)
        if sorted
            retval = retval.sort exportObj.sortHelper

        # Possibly adjust the upgrade
        if this_upgrade_obj?adjustment_func?
            (this_upgrade_obj.adjustment_func(upgrade) for upgrade in retval)
        else
            retval

    getSquadDialsAsHTML: () ->
        dialHTML = ""
        added_dials = {}
        for ship in @ships
            if ship.pilot? # There is always one "empty" ship at the bottom of each squad, that we want to skip. 
                maneuvers_unmodified = ship.data.maneuvers
                maneuvers_modified = ship.effectiveStats().maneuvers
                if not added_dials[ship.data.name]? or not (maneuvers_modified.toString() in added_dials[ship.data.name]) # we only want to add each dial once per ship (if two ships share a dial, add two copies of the dial)
                    added_dials[ship.data.name] = (added_dials[ship.data.name] ? []).concat [maneuvers_modified.toString()] # save maneuver as string, as that is easier to compare than arrays (if e.g. two ships of same type, one with and one without R4 are in a squad, we add 2 dials)
                    dialHTML += '<div class="fancy-dial">' + 
                                """<h4 class="ship-name-dial">#{if ship.data.display_name? then ship.data.display_name else ship.data.name}""" +
                                """#{if maneuvers_modified.toString() != maneuvers_unmodified.toString() then " (" + @uitranslation("modified") + ")" else ""}</h4>""" +
                                @getManeuverTableHTML(maneuvers_modified, maneuvers_unmodified) + '</div>'

        return """
                    <div class="print-dials-container">
                        #{dialHTML}
                    </div>
                """
                # dialHTML = @builder.getManeuverTableHTML(effective_stats.maneuvers, @data.maneuvers)


    # Converts a maneuver table for into an HTML table.
    getManeuverTableHTML: (maneuvers, baseManeuvers) ->
        if not maneuvers? or maneuvers.length == 0
            return @uitranslation("Missing maneuver info.")

        # Preprocess maneuvers to see which bearings are never used so we
        # don't render them.
        bearings_without_maneuvers = [0...maneuvers[0].length]
        for bearings in maneuvers
            for difficulty, bearing in bearings
                if difficulty > 0
                    bearings_without_maneuvers.removeItem bearing
        # console.log "bearings without maneuvers:"
        # console.dir bearings_without_maneuvers

        outTable = "<table><tbody>"

        for speed in [maneuvers.length - 1 .. 0]

            haveManeuver = false
            for v in maneuvers[speed]
                if v > 0
                    haveManeuver = true
                    break

            continue if not haveManeuver

            outTable += "<tr><td>#{speed}</td>"
            for turn in [0 ... maneuvers[speed].length]
                continue if turn in bearings_without_maneuvers

                outTable += "<td>"
                if maneuvers[speed][turn] > 0

                    color = switch maneuvers[speed][turn]
                        when 1 then "dodgerblue"
                        when 2 then "white"
                        when 3 then "red"
                        when 4 then "purple"

                     # we need this to change the color to b/w in case we want to print b/w

                    maneuverClass = switch maneuvers[speed][turn]
                        when 1 then "svg-blue-maneuver"
                        when 2 then "svg-white-maneuver"
                        when 3 then "svg-red-maneuver"
                        when 4 then "svg-purple-maneuver"

                    outTable += """<svg xmlns="http://www.w3.org/2000/svg" width="30px" height="30px" viewBox="0 0 200 200">"""

                    outlineColor = "black"
                    maneuverClass2 = "svg-base-maneuver"
                    if maneuvers[speed][turn] != baseManeuvers[speed][turn]
                        outlineColor = "DarkSlateGrey" # highlight manuevers modified by another card (e.g. R2 Astromech makes all 1 & 2 speed maneuvers green)
                        maneuverClass2 = "svg-modified-maneuver"

                    if speed == 0 and turn == 2
                        outTable += """<rect class="svg-maneuver-stop #{maneuverClass} #{maneuverClass2}" x="50" y="50" width="100" height="100" style="fill:#{color}; stroke-width:5; stroke:#{outlineColor}" />"""
                    else
                        transform = ""
                        className = ""
                        switch turn
                            when 0
                                # turn left
                                linePath = "M160,180 L160,70 80,70"
                                innerPath = "M160,175 L160,70 70,70"
                                trianglePath = "M80,100 V40 L30,70 Z"
                            when 1
                                # bank left
                                linePath = "M150,180 S150,120 80,60"
                                innerPath = "M150,175 S150,120 80,60"
                                trianglePath = "M80,100 V40 L30,70 Z"
                                transform = "transform='translate(-5 -15) rotate(45 70 90)' "
                            when 2
                                # straight
                                linePath = "M100,180 L100,100 100,80"
                                innerPath = "M100,175 L100,120 100,70"
                                trianglePath = "M70,80 H130 L100,30 Z"
                            when 3
                                # bank right
                                linePath = "M50,180 S50,120 120,60"
                                innerPath = "M50,175 S50,120 120,60"
                                trianglePath = "M120,100 V40 L170,70 Z"
                                transform = "transform='translate(5 -15) rotate(-45 130 90)' "
                            when 4
                                # turn right
                                linePath = "M40,180 L40,70 120,70"
                                innerPath = "M40,175 L40,70 130,70"
                                trianglePath = "M120,100 V40 L170,70 Z"
                            when 5
                                # k-turn/u-turn
                                linePath = "M50,180 L50,100 C50,10 140,10 140,100 L140,120"
                                innerPath = "M50,175 L50,100 C50,10 140,10 140,100 L140,130"
                                trianglePath = "M170,120 H110 L140,180 Z"
                            when 6
                                # segnor's loop left
                                linePath = "M150,180 S150,120 80,60"
                                innerPath = "M150,175 S150,120 85,65"
                                trianglePath = "M80,100 V40 L30,70 Z"
                                transform = "transform='translate(0 50)'"
                            when 7
                                # segnor's loop right
                                linePath = "M50,180 S50,120 120,60"
                                innerPath = "M50,175 S50,120 115,65"
                                trianglePath = "M120,100 V40 L170,70 Z"
                                transform = "transform='translate(0 50)'"
                            when 8
                                # tallon roll left
                                linePath = "M160,180 L160,70 80,70"
                                innerPath = "M160,175 L160,70 85,70"
                                trianglePath = "M60,100 H100 L80,140 Z"
                            when 9
                                # tallon roll right
                                linePath = "M40,180 L40,70 120,70"
                                innerPath = "M40,175 L40,70 115,70"
                                trianglePath = "M100,100 H140 L120,140 Z"
                            when 10
                                # backward left
                                linePath = "M50,180 S50,120 120,60"
                                innerPath = "M50,175 S50,120 120,60"
                                trianglePath = "M120,100 V40 L170,70 Z"
                                transform = "transform='translate(5 -15) rotate(-45 130 90)' "
                                className = 'backwards'
                            when 11
                                # backward straight
                                linePath = "M100,180 L100,100 100,80"
                                innerPath = "M100,175 L100,100 100,70"
                                trianglePath = "M70,80 H130 L100,30 Z"
                                className = 'backwards'
                            when 12
                                # backward right
                                linePath = "M150,180 S150,120 80,60"
                                innerPath = "M150,175 S150,120 80,60"
                                trianglePath = "M80,100 V40 L30,70 Z"
                                transform = "transform='translate(-5 -15) rotate(45 70 90)' "
                                className = 'backwards'

                        outTable += $.trim """
                          <g class="maneuver #{className}">
                            <path class = 'svg-maneuver-outer #{maneuverClass} #{maneuverClass2}' stroke-width='25' fill='none' stroke='#{outlineColor}' d='#{linePath}' />
                            <path class = 'svg-maneuver-triangle #{maneuverClass} #{maneuverClass2}' d='#{trianglePath}' fill='#{color}' stroke-width='5' stroke='#{outlineColor}' #{transform}/>
                            <path class = 'svg-maneuver-inner #{maneuverClass} #{maneuverClass2}' stroke-width='15' fill='none' stroke='#{color}' d='#{innerPath}' />
                          </g>
                        """

                    outTable += "</svg>"
                outTable += "</td>"
            outTable += "</tr>"
        outTable += "</tbody></table>"
        outTable

    formatActions: (actions,seperation,keyword=[]) ->
        action_icons = []
        for action in actions
            color = ""
            prefix = seperation
            if "Droid" in keyword
                action = action.replace('Focus', 'Calculate')
            # Search and filter each type of action by its prefix and then reformat it for html
            if action.search('> ') != -1
                action = action.replace(/> /gi, '')
                prefix = """ <i class="xwing-miniatures-font xwing-miniatures-font-linked"></i> """
            if action.search('F-') != -1 
                color = "force "
                action = action.replace(/F-/gi, '')
            if action.search('W-') != -1 
                prefix = "White "
                action = action.replace(/W-/gi, '')
            else if action.search('R-') != -1 
                color = "red "
                action = action.replace(/R-/gi, '')
            action = action.toLowerCase().replace(/[^0-9a-z]/gi, '')
            action_icons.push """#{prefix}<i class="xwing-miniatures-font #{color}xwing-miniatures-font-#{action}"></i>"""
        actionlist = action_icons.join ''
        return actionlist.replace(seperation,'')

    listStandardUpgrades: (upgrades) ->
        upgrade_names = ''
        for upgrade in upgrades
            formattedname = upgrade.split " ("
            upgrade_names += ', ' + formattedname[0]
        return upgrade_names.substr 2

    getPilotsMatchingUpgrade: (term='',sorted = true) ->
        pilots = []
        for pilot_name, pilot_data of exportObj.pilots
            if pilot_data.upgrades?
                for upgrade in pilot_data.upgrades
                    if @matcher(upgrade, term)
                        pilots.push
                            id: pilot_data.name
                            name: pilot_data.name
                            display_name: pilot_data.display_name
                            chassis: pilot_data.chassis
                            canonical_name: pilot_data.canonical_name
                            xws: pilot_data.name.canonicalize()
                            icon: if pilot_data.icon then pilot_data.icon else pilot_data.name.canonicalize()
        if sorted
            pilots.sort exportObj.sortHelper
        return pilots

    showTooltip: (type, data, additional_opts, container = @info_container, force_update = false) ->
        if data != @tooltip_currently_displaying or force_update
            switch type
                when 'Ship'
            # we get all pilots for the ship, to display stuff like available slots which are treated as pilot properties, not ship properties (which makes sense, as they depend on the pilot, e.g. talent or force slots)
                    possible_inis = []
                    possible_costs = []
                    possible_loadout = []
                    slot_types = {} # one number per slot: 0: not available for that ship. 1: always available for that ship. 2: available for some pilots on that ship. 3: slot two times availabel for that ship 4: slot one or two times available (depending on pilot) 5: slot zero to two times available 6: slot three times available (no mixed-case implemented) -1: undefined
                    for slot of exportObj.upgradesBySlotCanonicalName
                        slot_types[slot] = -1
                    for name, pilot of exportObj.pilots
                        # skip all pilots with wrong ship or faction
                        if pilot.ship != data.name or not @isOurFaction(pilot.faction) 
                            continue
                        if not (pilot.skill in possible_inis)
                            possible_inis.push(pilot.skill)
                        if @isXwa and pilot.pointsxwa?
                            possible_costs.push(pilot.pointsxwa)
                        else
                            possible_costs.push(pilot.points)
                        if @isXwa and pilot.loadoutxwa?
                            possible_loadout.push(pilot.loadoutxwa)
                        else
                            if pilot.loadout? then possible_loadout.push(pilot.loadout)
                        if pilot.slots?
                            for slot, state of slot_types
                                switch pilot.slots.filter((item) => item == slot).length
                                    when 1
                                        switch state
                                            when -1
                                                slot_types[slot] = 1
                                            when 0
                                                slot_types[slot] = 2
                                            when 3
                                                slot_types[slot] = 4
                                    when 0
                                        switch state
                                            when -1
                                                slot_types[slot] = 0
                                            when 1
                                                slot_types[slot] = 2
                                            when 3,4
                                                slot_types[slot] = 5
                                    when 2
                                        switch state
                                            when -1
                                                slot_types[slot] = 3
                                            when 0,2
                                                slot_types[slot] = 5
                                            when 1
                                                slot_types[slot] = 4
                                    when 3
                                        slot_types[slot] = 6
                                
                    possible_inis.sort()
        
                    container.find('.info-type').text exportObj.translate("types", type)
                    container.find('.info-name').html """#{if data.display_name then data.display_name else data.name}#{if exportObj.isReleased(data) then "" else " (#{@uitranslation('unreleased')})"}"""
                    if @collection?.counts?
                        ship_count = @collection.counts?.ship?[data.name] ? 0
                        container.find('.info-collection').text @uitranslation("collectionContentShips", ship_count)
                        container.find('.info-collection').show()
                    else
                        container.find('.info-collection').hide()
                    first = true
                    inis = String(possible_inis[0])
                    for ini in possible_inis
                        if not first
                            inis += ", " + ini
                        first = false
                    container.find('tr.info-skill td.info-data').text inis
                    container.find('tr.info-skill').toggle(ini != undefined)

                    # display point range for that ship (and faction) 
                    point_range_text = "#{Math.min possible_costs...} - #{Math.max possible_costs...}"
                    container.find('tr.info-points td.info-data').text point_range_text
                    loadout_range_text = "#{Math.min possible_loadout...} - #{Math.max possible_loadout...}"
                    container.find('tr.info-loadout td.info-data').text loadout_range_text
                    container.find('tr.info-points').toggle(possible_costs.length > 0)
                    container.find('tr.info-loadout').toggle(possible_loadout.length > 0)
                    
                    container.find('tr.info-engagement').hide()
                
                    container.find('tr.info-attack td.info-data').text(data.attack)
                    container.find('tr.info-attack-bullseye td.info-data').text(data.attackbull)
                    container.find('tr.info-attack-fullfront td.info-data').text(data.attackf)
                    container.find('tr.info-attack-left td.info-data').text(data.attackl)
                    container.find('tr.info-attack-right td.info-data').text(data.attackr)
                    container.find('tr.info-attack-back td.info-data').text(data.attackb)
                    container.find('tr.info-attack-turret td.info-data').text(data.attackt)
                    container.find('tr.info-attack-doubleturret td.info-data').text(data.attackdt)
        
                    container.find('tr.info-attack').toggle(data.attack?)
                    container.find('tr.info-attack-bullseye').toggle(data.attackbull?)
                    container.find('tr.info-attack-fullfront').toggle(data.attackf?)
                    container.find('tr.info-attack-left').toggle(data.attackl?)
                    container.find('tr.info-attack-right').toggle(data.attackr?)
                    container.find('tr.info-attack-back').toggle(data.attackb?)
                    container.find('tr.info-attack-turret').toggle(data.attackt?)
                    container.find('tr.info-attack-doubleturret').toggle(data.attackdt?)
                
                    container.find('tr.info-ship').hide()        
                    if data.base?
                        container.find('tr.info-base td.info-data').text exportObj.translate("gameterms", data.base)
                    else
                        container.find('tr.info-base td.info-data').text exportObj.translate("gameterms", "Small")
                    container.find('tr.info-base').show()
                    container.find('tr.info-faction td.info-data').text [exportObj.translate("faction", faction) for faction in data.factions]
                    container.find('tr.info-faction').hide() # this information is clear from the context, unless we are in card browser

                    container.find('p.info-restrictions').hide()

                    for cls in container.find('tr.info-attack td.info-header i.xwing-miniatures-font')[0].classList
                        container.find('tr.info-attack td.info-header i.xwing-miniatures-font').removeClass(cls) if cls.startsWith('xwing-miniatures-font-attack')
                    container.find('tr.info-attack td.info-header i.xwing-miniatures-font').addClass(data.attack_icon ? 'xwing-miniatures-font-attack')
        
                    container.find('tr.info-range').hide()
                    container.find('tr.info-agility td.info-data').text(data.agility)
                    container.find('tr.info-agility').toggle(data.agility?)
                    container.find('tr.info-hull td.info-data').text(data.hull)
                    container.find('tr.info-hull').toggle(data.hull?)
                    
                    recurringicon = ''
                    if data.shieldrecurr?
                        count = 0
                        while count < data.shieldrecurr
                            recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
                            ++count
                    container.find('tr.info-shields td.info-data').html (data.shields + recurringicon)
                    container.find('tr.info-shields').toggle(data.shields?)

                    recurringicon = ''
                    if data.energyrecurr?
                        count = 0
                        while count < data.energyrecurr
                            recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
                            ++count
                    container.find('tr.info-energy td.info-data').html (data.energy + recurringicon)
                    container.find('tr.info-energy').toggle(data.energy?)
                    
                    
                    # One may want to check for force sensitive pilots and display the possible values here (like done for ini), but I'll skip this for now. 
                    container.find('tr.info-force').hide() 
        
                    container.find('tr.info-charge').hide()
        
                    container.find('tr.info-actions td.info-data').html @formatActions(data.actions, ", ", data.keyword ? [])
                    container.find('tr.info-actions').show()

                    # Display all available slots, put brackets around slots that are only available for some pilots
                    container.find('tr.info-upgrades').show()
                    container.find('tr.info-upgrades td.info-data').html(((if state == 1 then exportObj.translate('sloticon', slot) else (if state == 2 then '('+exportObj.translate('sloticon', slot)+')' else (if state == 3 then (exportObj.translate('sloticon', slot) + exportObj.translate('sloticon', slot)) else (if state == 4 then (exportObj.translate('sloticon', slot) + '(' + exportObj.translate('sloticon', slot) + ')') else (if state == 5 then ('(' + exportObj.translate('sloticon', slot) + exportObj.translate('sloticon', slot) + ')') else (if state == 6 then (exportObj.translate('sloticon',slot) + exportObj.translate('sloticon',slot) + exportObj.translate('sloticon',slot)))))))) for slot, state of slot_types).join(' ') or 'None')
                
                    container.find('p.info-text').hide()

                    container.find('p.info-chassis').show()
                    container.find('p.info-chassis').html if data.chassis? then "<strong>#{exportObj.chassis[data.chassis]?.display_name ? data.chassis}:</strong> #{exportObj.chassis[data.chassis].text}" else ""

                    container.find('p.info-maneuvers').show()
                    container.find('p.info-maneuvers').html(@getManeuverTableHTML(data.maneuvers, data.maneuvers))
                    
                    sources = (exportObj.translate('sources', source) for source in data.sources).sort()
                    container.find('.info-sources.info-data').text if (sources.length > 1) or (not (exportObj.translate('sources', 'Loose Ships') in sources)) then (if sources.length > 0 then sources.join(', ') else exportObj.translate('ui', 'unreleased')) else @uitranslation("Only available from 1st edition")
                    container.find('.info-sources').show()
                when 'Pilot'
                    container.find('.info-type').text exportObj.translate("types", type)
                    container.find('.info-sources.info-data').text (exportObj.translate('sources', source) for source in data.sources).sort().join(', ')
                    container.find('.info-sources').show()
                    if @collection?.counts?
                        pilot_count = @collection.counts?.pilot?[data.name] ? 0
                        ship_count = @collection.counts.ship?[data.ship] ? 0
                        container.find('.info-collection').text @uitranslation("collectionContentShipsAndPilots", ship_count, pilot_count)
                        container.find('.info-collection').show()
                    else
                        container.find('.info-collection').hide()
                        
                    # if the pilot is already selected and has uprades, some stats may be modified
                    if additional_opts?.effectiveStats?
                        effective_stats = additional_opts.effectiveStats()
                    #logic to determine how many dots to use for uniqueness
                    if data.unique?
                        uniquedots = "&middot;&nbsp;"
                    else if data.max_per_squad?
                        count = 0
                        uniquedots = ""
                        while (count < data.max_per_squad)
                            uniquedots = uniquedots.concat("&middot;")
                            ++count
                        uniquedots = uniquedots.concat("&nbsp;")
                    else
                        uniquedots = ""
                        
                    container.find('.info-name').html """#{uniquedots}#{if data.display_name then data.display_name else data.name}#{if exportObj.isReleased(data) then "" else " (#{exportObj.translate('ui', 'unreleased')})"}"""

                    restriction_info = @restriction_text(data) + @upgrade_effect(data)
                    if restriction_info != '' and data.ship != "Conversion"
                        container.find('p.info-restrictions').html restriction_info
                        container.find('p.info-restrictions').show()
                    else
                        container.find('p.info-restrictions').hide()

                    container.find('p.info-text').html data.text ? ''
                    container.find('p.info-text').show()

                    ship = exportObj.ships[data.ship]

                    if effective_stats?.chassis? and (effective_stats.chassis != "")
                        chassis_title = effective_stats.chassis
                    else if data.chassis?
                        chassis_title = data.chassis
                    else if ship.chassis?
                        chassis_title = ship.chassis
                    else
                        chassis_title = ""

                    if chassis_title != ""
                        container.find('p.info-chassis').html "<strong>#{exportObj.chassis[chassis_title]?.display_name ? chassis_title}:</strong> #{exportObj.chassis[chassis_title].text}"
                        container.find('p.info-chassis').show()
                    else
                        container.find('p.info-chassis').hide()

                    container.find('tr.info-ship td.info-data').text data.ship
                    container.find('tr.info-ship').show()
                    container.find('tr.info-faction td.info-data').text exportObj.translate("faction", data.faction)
                    container.find('tr.info-faction').hide() # this information is clear from the context, unless we are in card browser
                    if ship.base?
                        container.find('tr.info-base td.info-data').text exportObj.translate("gameterms", ship.base)
                    else
                        container.find('tr.info-base td.info-data').text exportObj.translate("gameterms", "Small")
                    container.find('tr.info-base').show()

                    
                    container.find('tr.info-skill td.info-data').text data.skill
                    container.find('tr.info-skill').toggle(data.skill?)

                    container.find('tr.info-points td.info-data').text (if @isXwa and data.pointsxwa? then data.pointsxwa else data.points)
                    container.find('tr.info-points').show()

                    container.find('tr.info-loadout td.info-data').text (if @isXwa and data.loadoutxwa? then data.loadoutxwa else data.loadout)
                    if data.upgrades?
                        container.find('tr.info-loadout').hide()
                    else
                        container.find('tr.info-loadout').show()
                    if data.engagement?
                        container.find('tr.info-engagement td.info-data').text data.engagement
                        container.find('tr.info-engagement').show()
                    else
                        container.find('tr.info-engagement').hide()
                    
                    container.find('tr.info-attack td.info-header i.xwing-miniatures-font').addClass(ship.attack_icon ? 'xwing-miniatures-font-attack')

                    container.find('tr.info-attack td.info-data').text statAndEffectiveStat((data.ship_override?.attack ? ship.attack), effective_stats, 'attack')
                    container.find('tr.info-attack').toggle(((data.ship_override?.attack ? ship.attack) > 0) or (effective_stats?.attack? and effective_stats?.attack > 0))

                    container.find('tr.info-attack-fullfront td.info-data').text statAndEffectiveStat((data.ship_override?.attackf ? ship.attackf), effective_stats, 'attackf')
                    container.find('tr.info-attack-fullfront').toggle(ship.attackf? or effective_stats?.attackf?)
                    
                    container.find('tr.info-attack-bullseye td.info-data').text statAndEffectiveStat((data.ship_override?.attackbull ? ship.attackbull), effective_stats, 'attackbull')
                    container.find('tr.info-attack-bullseye').toggle(ship.attackbull? or effective_stats?.attackbull?)

                    container.find('tr.info-attack-left td.info-data').text statAndEffectiveStat((data.ship_override?.attackl ? ship.attackl), effective_stats, 'attackl')
                    container.find('tr.info-attack-left').toggle(ship.attackl? or effective_stats?.attackl?)

                    container.find('tr.info-attack-right td.info-data').text statAndEffectiveStat((data.ship_override?.attackr ? ship.attackr), effective_stats, 'attackr')
                    container.find('tr.info-attack-right').toggle(ship.attackr? or effective_stats?.attackr?)
                    
                    container.find('tr.info-attack-back td.info-data').text statAndEffectiveStat((data.ship_override?.attackb ? ship.attackb), effective_stats, 'attackb')
                    container.find('tr.info-attack-back').toggle(ship.attackb? or effective_stats?.attackb?)

                    container.find('tr.info-attack-turret td.info-data').text statAndEffectiveStat((data.ship_override?.attackt ? ship.attackt), effective_stats, 'attackt')
                    container.find('tr.info-attack-turret').toggle(data.ship_override?.attackt? or ship.attackt? or effective_stats?.attackt?)

                    container.find('tr.info-attack-doubleturret td.info-data').text statAndEffectiveStat((data.ship_override?.attackdt ? ship.attackdt), effective_stats, 'attackdt')
                    container.find('tr.info-attack-doubleturret').toggle(ship.attackdt? or effective_stats?.attackdt?)

                    container.find('tr.info-range').hide()
                    container.find('td.info-rangebonus').hide()
                    container.find('tr.info-agility td.info-data').text statAndEffectiveStat((data.ship_override?.agility ? ship.agility), effective_stats, 'agility')
                    container.find('tr.info-agility').toggle(data.ship_override?.agility? or ship.agility?)
                    container.find('tr.info-hull td.info-data').text statAndEffectiveStat((data.ship_override?.hull ? ship.hull), effective_stats, 'hull')
                    container.find('tr.info-hull').toggle(data.ship_override?.hull? or ship.hull?)

                    recurringicon = ''
                    if ship.shieldrecurr?
                        count = 0
                        while count < ship.shieldrecurr
                            recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
                            ++count
                    container.find('tr.info-shields td.info-data').html (statAndEffectiveStat((data.ship_override?.shields ? ship.shields), effective_stats, 'shields') + recurringicon)
                    container.find('tr.info-shields').toggle(data.ship_override?.shields? or ship.shields?)

                    recurringicon = ''
                    if ship.energyrecurr?
                        count = 0
                        while count < ship.energyrecurr
                            recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
                            ++count
                    container.find('tr.info-energy td.info-data').html (statAndEffectiveStat((data.ship_override?.energy ? ship.energy), effective_stats, 'energy') + recurringicon)
                    container.find('tr.info-energy').toggle(data.ship_override?.energy? or ship.energy?)
                    
                    
                    if (effective_stats?.force? and effective_stats.force > 0) or data.force?
                        recurringicon = ''
                        forcerecurring = 1
                        if effective_stats?.forcerecurring? 
                            forcerecurring = effective_stats.forcerecurring
                        else if data.forcerecurring?
                            forcerecurring = data.forcerecurring
                        count = 0
                        while count < forcerecurring                        
                            recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
                            ++count
                        container.find('tr.info-force td.info-data').html (statAndEffectiveStat((data.ship_override?.force ? data.force), effective_stats, 'force') + recurringicon)
                        container.find('tr.info-force').show()
                    else
                        container.find('tr.info-force').hide()

                    if data.charge?
                        recurringicon = ''
                        if data.recurring?
                            if data.recurring > 0
                                count = 0
                                while count < data.recurring
                                    recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
                                    ++count
                            else
                                count = data.recurring
                                while count < 0
                                    recurringicon += '<sub><i class="fas fa-caret-down"></i></sub>'
                                    ++count
                        chargeHTML = $.trim """#{data.charge}#{recurringicon}"""
                        container.find('tr.info-charge td.info-data').html (chargeHTML)
                        container.find('tr.info-charge').show()
                    else
                        container.find('tr.info-charge').hide()

                    if effective_stats?.actions?
                        container.find('tr.info-actions td.info-data').html @formatActions(data.ship_override?.actions ? effective_stats.actions, ", ")
                    else
                        container.find('tr.info-actions td.info-data').html @formatActions(data.ship_override?.actions ? ship.actions, ", ", data.keyword ? [])
                    
                    container.find('tr.info-actions').show()
                    if @isQuickbuild
                        container.find('tr.info-upgrades').hide()
                    else
                        container.find('tr.info-upgrades').show()
                        if @isXwa and data.slotsxwa?
                            container.find('tr.info-upgrades td.info-data').html(if data.slotsxwa? then (exportObj.translate('sloticon', slot) for slot in data.slotsxwa).join(' ') else (if data.upgrades? then @listStandardUpgrades(data.upgrades) else 'None'))
                        else
                            container.find('tr.info-upgrades td.info-data').html(if data.slots? then (exportObj.translate('sloticon', slot) for slot in data.slots).join(' ') else (if data.upgrades? then @listStandardUpgrades(data.upgrades) else 'None'))
                    container.find('p.info-maneuvers').show()
                    maneuvers_override = data.ship_override?.maneuvers ? ship.maneuvers
                    container.find('p.info-maneuvers').html(@getManeuverTableHTML(effective_stats?.maneuvers ? maneuvers_override, maneuvers_override))
                when 'Quickbuild'
                    container.find('.info-type').text @uitranslation('Quickbuild')
                    container.find('.info-sources').hide() # there are different sources for the pilot and the upgrade cards, so we won't display any
                    container.find('.info-collection').hide() # same here, hard to give a single number telling a user how often he ownes all required cards
                    
                    pilot = exportObj.pilots[data.pilot]
                    ship = exportObj.ships[data.ship]

                    #logic to determine how many dots to use for uniqueness
                    if pilot.unique?
                        uniquedots = "&middot;&nbsp;"
                    else if pilot.max_per_squad?
                        count = 0
                        uniquedots = ""
                        while (count < data.max_per_squad)
                            uniquedots = uniquedots.concat("&middot;")
                            ++count
                        uniquedots = uniquedots.concat("&nbsp;")
                    else
                        uniquedots = ""
                        
                    container.find('.info-name').html """#{uniquedots}#{if pilot.display_name then pilot.display_name else pilot.name}#{if data.suffix? then data.suffix else ""}#{if exportObj.isReleased(pilot) then "" else " (#{exportObj.translate('ui', 'unreleased')})"}"""


                    restriction_info = @restriction_text(data) + @upgrade_effect(data)
                    if restriction_info != ''
                        container.find('p.info-restrictions').html restriction_info ? ''
                        container.find('p.info-restrictions').show()
                    else
                        container.find('p.info-restrictions').hide()

                    container.find('p.info-text').html pilot.text ? ''
                    container.find('p.info-text').show()

                    container.find('p.info-chassis').html if pilot.chassis? then "<strong>#{exportObj.chassis[pilot.chassis]?.display_name ? pilot.chassis}:</strong> #{exportObj.chassis[pilot.chassis].text}" else (if ship.chassis?then "<strong>#{ship.chassis}:</strong> #{exportObj.chassis[ship.chassis].text}" else "")
                    container.find('p.info-chassis').show()

                    container.find('tr.info-ship td.info-data').text data.ship
                    container.find('tr.info-ship').show()
                    container.find('tr.info-faction td.info-data').text exportObj.translate("faction", data.faction)
                    container.find('tr.info-faction').hide() # this information is clear from the context, unless we are in card browser

                    if ship.base?
                        container.find('tr.info-base td.info-data').text exportObj.translate("gameterms", ship.base)
                    else
                        container.find('tr.info-base td.info-data').text exportObj.translate("gameterms", "Small")
                    container.find('tr.info-base').show()

                    container.find('tr.info-skill td.info-data').text pilot.skill
                    container.find('tr.info-skill').show()
                    container.find('tr.info-points').hide()
                    container.find('tr.info-loadout').hide()
                    container.find('tr.info-engagement td.info-data').text pilot.skill
                    container.find('tr.info-engagement').show()

                    container.find('tr.info-attack td.info-data').text(pilot.ship_override?.attack ? ship.attack)
                    container.find('tr.info-attack').toggle((pilot.data.ship_override?.attack ? ship.attack) > 0)

                    container.find('tr.info-attack-fullfront td.info-data').text(ship.attackf)
                    container.find('tr.info-attack-fullfront').toggle(ship.attackf?)
                    
                    container.find('tr.info-attack-bullseye td.info-data').text(ship.attackbull)
                    container.find('tr.info-attack-bullseye').toggle(ship.attackbull?)
                    container.find('tr.info-attack-left td.info-data').text(ship.attackl)
                    container.find('tr.info-attack-left').toggle(ship.attackl?)
                    container.find('tr.info-attack-right td.info-data').text(ship.attackr)
                    container.find('tr.info-attack-right').toggle(ship.attackr?)
                    container.find('tr.info-attack-back td.info-data').text(ship.attackb)
                    container.find('tr.info-attack-back').toggle(ship.attackb?)
                    container.find('tr.info-attack-turret td.info-data').text(ship.attackt)
                    container.find('tr.info-attack-turret').toggle(ship.attackt?)
                    container.find('tr.info-attack-doubleturret td.info-data').text(ship.attackdt)
                    container.find('tr.info-attack-doubleturret').toggle(ship.attackdt?)
                    
                    container.find('tr.info-attack td.info-header i.xwing-miniatures-font').addClass(ship.attack_icon ? 'xwing-miniatures-font-frontarc')

                    container.find('tr.info-energy td.info-data').text(pilot.ship_override?.energy ? ship.energy)
                    container.find('tr.info-energy').toggle(pilot.ship_override?.energy? or ship.energy?)
                    container.find('tr.info-range').hide()
                    container.find('td.info-rangebonus').hide()
                    container.find('tr.info-agility td.info-data').text(pilot.ship_override?.agility ? ship.agility)
                    container.find('tr.info-agility').show()
                    container.find('tr.info-hull td.info-data').text(pilot.ship_override?.hull ? ship.hull)
                    container.find('tr.info-hull').show()
                    container.find('tr.info-shields td.info-data').text(pilot.ship_override?.shields ? ship.shields)
                    container.find('tr.info-shields').show()

                    if effective_stats?.force? or data.force?
                        recurringicon = ''
                        forcerecurring = 1
                        if effective_stats?.forcerecurring?
                            forcerecurring = effective_stats.forcerecurring
                        count = 0
                        while count < forcerecurring
                            recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
                            ++count
                        container.find('tr.info-force td.info-data').html ((pilot.ship_override?.force ? pilot.force)+ recurringicon)
                        container.find('tr.info-force').show()
                    else
                        container.find('tr.info-force').hide()

                    if data.charge?
                        recurringicon = ''
                        if data.recurring?
                            if data.recurring > 0
                                count = 0
                                while count < data.recurring
                                    recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
                                    ++count
                            else
                                count = data.recurring
                                while count < 0
                                    recurringicon += '<sub><i class="fas fa-caret-down"></i></sub>'
                                    ++count
                        chargeHTML = $.trim """#{data.charge}#{recurringicon}"""
                        container.find('tr.info-charge td.info-data').html (chargeHTML)
                        container.find('tr.info-charge').show()
                    else
                        container.find('tr.info-charge').hide()

                    container.find('tr.info-actions td.info-data').html @formatActions(pilot.ship_override?.actions ? exportObj.ships[data.ship].actions, ", ", pilot.keyword ? [])
    
                    container.find('tr.info-actions').show()
                    container.find('tr.info-upgrades').show()
                    container.find('tr.info-upgrades td.info-data').html(((if exportObj.upgrades[upgrade].display_name? then exportObj.upgrades[upgrade].display_name else upgrade) for upgrade in (data.upgrades ? [])).join(', ') or 'None')
                    container.find('p.info-maneuvers').show()
                    container.find('p.info-maneuvers').html(@getManeuverTableHTML(ship.maneuvers, ship.maneuvers))
                when 'Addon'
                    container.find('.info-type').text exportObj.translate("slot", additional_opts.addon_type)
                    if data.standard?
                        matching_pilots = @getPilotsMatchingUpgrade(data.name, false)
                        container.find('.info-sources.info-data').text (pilot.display_name for pilot in matching_pilots).sort().join(', ')
                    else
                        container.find('.info-sources.info-data').text (exportObj.translate('sources', source) for source in data.sources).sort().join(', ')
                    container.find('.info-sources').show()
                    
                    #logic to determine how many dots to use for uniqueness
                    if data.unique?
                        uniquedots = "&middot;&nbsp;"
                    else if data.max_per_squad?
                        count = 0
                        uniquedots = ""
                        while (count < data.max_per_squad)
                            uniquedots = uniquedots.concat("&middot;")
                            ++count
                        uniquedots = uniquedots.concat("&nbsp;")
                    else
                        uniquedots = ""
                    
                    
                    if @collection?.counts? and (not data.standard?)
                        addon_count = @collection.counts?['upgrade']?[data.name] ? 0
                        container.find('.info-collection').text @uitranslation("collectionContentUpgrades", addon_count)
                        container.find('.info-collection').show()
                    else
                        container.find('.info-collection').hide()
                    container.find('.info-name').html """#{uniquedots}#{if data.display_name then data.display_name else data.name}#{if (exportObj.isReleased(data) or data.standard?) then  "" else " (#{@uitranslation('unreleased')})"}#{if data.standard? then " (S)" else ""}"""
                    
                    if @isXwa and data.pointsxwa? then points = data.pointsxwa else points = data.points
                    if Array.isArray(points)
                        point_info = "<i>" + @uitranslation("varPointCostsPoints", points)
                        switch data.variablepoints
                            when "Agility"
                                point_info += @uitranslation("varPointCostsConditionAgility", [0..points.length-1])
                            when "Initiative"
                                point_info += @uitranslation("varPointCostsConditionIni", [0..points.length-1])
                            when "Base"
                                point_info += @uitranslation("varPointCostsConditionBase")
                            when "Faction"
                                point_info += @uitranslation("varPointCostsConditionFaction", data.faction)
                        point_info += "</i>"

                    restriction_info = @restriction_text(data) + @upgrade_effect(data)
                    if point_info? or (restriction_info != '')
                        if point_info? and (restriction_info != '')
                            point_info += "<br/>"
                        container.find('p.info-restrictions').html (point_info ? '') + restriction_info
                        container.find('p.info-restrictions').show()
                    else
                        container.find('p.info-restrictions').hide()

                    container.find('p.info-text').html (data.text ? '')
                    container.find('p.info-text').show()
                    container.find('p.info-chassis').hide()
                    container.find('tr.info-ship').hide()
                    container.find('tr.info-faction').hide()
                    container.find('tr.info-base').hide()
                    container.find('tr.info-skill').hide()
                    container.find('tr.info-points').hide()
                    container.find('tr.info-loadout').hide()
                    container.find('tr.info-engagement').hide()
                    if data.energy?
                        container.find('tr.info-energy td.info-data').text data.energy
                        container.find('tr.info-energy').show()
                    else
                        container.find('tr.info-energy').hide()
                    if data.attack?
                        container.find('tr.info-attack td.info-data').text data.attack
                        container.find('tr.info-attack').show()
                    else
                        container.find('tr.info-attack').hide()

                    if data.attackb?
                        container.find('tr.info-attack-back td.info-data').text data.attackb
                        container.find('tr.info-attack-back').show()
                    else
                        container.find('tr.info-attack-back').hide()

                    if data.attackt?
                        container.find('tr.info-attack-turret td.info-data').text data.attackt
                        container.find('tr.info-attack-turret').show()
                    else
                        container.find('tr.info-attack-turret').hide()

                    if data.attackr?
                        container.find('tr.info-attack-right td.info-data').text data.attackr
                        container.find('tr.info-attack-right').show()
                    else
                        container.find('tr.info-attack-right').hide()

                    if data.attackl?
                        container.find('tr.info-attack-left td.info-data').text data.attackl
                        container.find('tr.info-attack-left').show()
                    else
                        container.find('tr.info-attack-left').hide()

                    if data.attackdt?
                        container.find('tr.info-attack-doubleturret td.info-data').text data.attackdt
                        container.find('tr.info-attack-doubleturret').show()
                    else
                        container.find('tr.info-attack-doubleturret').hide()
                        
                    if data.attackbull?
                        container.find('tr.info-attack-bullseye td.info-data').text data.attackbull
                        container.find('tr.info-attack-bullseye').show()
                    else
                        container.find('tr.info-attack-bullseye').hide()

                    if data.attackf?
                        container.find('tr.info-attack-fullfront td.info-data').text data.attackf
                        container.find('tr.info-attack-fullfront').show()
                    else
                        container.find('tr.info-attack-fullfront').hide()
                        
                    if data.charge?
                        recurringicon = ''
                        if data.recurring?
                            if data.recurring > 0
                                count = 0
                                while count < data.recurring
                                    recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
                                    ++count
                            else
                                count = data.recurring
                                while count < 0
                                    recurringicon += '<sub><i class="fas fa-caret-down"></i></sub>'
                                    ++count
                        chargeHTML = $.trim """#{data.charge}#{recurringicon}"""
                        container.find('tr.info-charge td.info-data').html (chargeHTML)
                    container.find('tr.info-charge').toggle(data.charge?)

                    if data.range?
                        container.find('tr.info-range td.info-data').text data.range
                        container.find('tr.info-range').show()
                    else
                        container.find('tr.info-range').hide()

                    if data.rangebonus?
                        container.find('td.info-rangebonus').show()
                    else
                        container.find('td.info-rangebonus').hide()
                        
                    if data.force?
                        recurringicon = ''
                        forcerecurring = 1
                        if data.forcerecurring?
                            forcerecurring = data.forcerecurring
                        count = 0
                        while count < forcerecurring
                            recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
                            ++count
                        container.find('tr.info-force td.info-data').html (data.force + recurringicon)
                    container.find('tr.info-force').toggle(data.force?)                        

                    container.find('tr.info-agility').hide()
                    container.find('tr.info-hull').hide()
                    container.find('tr.info-shields').hide()
                    container.find('tr.info-actions').hide()
                    container.find('tr.info-upgrades').hide()
                    container.find('p.info-maneuvers').hide()
                when 'Rules'
                    container.find('.info-type').hide()
                    container.find('.info-sources').hide()
                    container.find('.info-collection').hide()
                    container.find('.info-name').html data.name
                    container.find('.info-name').show()
                    container.find('p.info-restrictions').hide()
                    container.find('p.info-text').html data.text
                    container.find('p.info-text').show()
                    container.find('tr.info-ship').hide()
                    container.find('tr.info-faction').hide()
                    container.find('tr.info-base').hide()
                    container.find('tr.info-skill').hide()
                    container.find('tr.info-points').hide()
                    container.find('tr.info-loadout').hide()
                    container.find('tr.info-agility').hide()
                    container.find('tr.info-hull').hide()
                    container.find('tr.info-shields').hide()
                    container.find('tr.info-actions').hide()
                    container.find('tr.info-upgrades').hide()
                    container.find('p.info-maneuvers').hide()
                    container.find('tr.info-energy').hide()
                    container.find('tr.info-attack').hide()
                    container.find('tr.info-attack-turret').hide()
                    container.find('tr.info-attack-bullseye').hide()
                    container.find('tr.info-attack-fullfront').hide()
                    container.find('tr.info-attack-back').hide()
                    container.find('tr.info-attack-doubleturret').hide()
                    container.find('tr.info-charge').hide()
                    container.find('td.info-rangebonus').hide()
                    container.find('tr.info-range').hide()
                    container.find('tr.info-force').hide()
                when 'MissingStuff'
                    container.find('.info-type').text @uitranslation("List of Missing items")
                    container.find('.info-sources').hide()
                    container.find('.info-collection').hide()
                    container.find('.info-name').html @uitranslation("Missing items")
                    container.find('.info-name').show()
                    missingStuffInfoText = @uitranslation("Missing Item List:")+"<ul>"
                    for item in data
                        missingStuffInfoText += """<li><strong>#{(if item.display_name? then item.display_name else item.name)}</strong> ("""
                        first = true
                        for source in item.sources
                            if not first
                                missingStuffInfoText += ", "
                            missingStuffInfoText += source
                            first = false
                        missingStuffInfoText += ")</li>"
                    missingStuffInfoText +="</ul>"
                    container.find('p.info-restrictions').hide()
                    container.find('p.info-text').html missingStuffInfoText
                    container.find('p.info-text').show()
                    container.find('tr.info-ship').hide()
                    container.find('tr.info-faction').hide()
                    container.find('tr.info-base').hide()
                    container.find('tr.info-skill').hide()
                    container.find('tr.info-points').hide()
                    container.find('tr.info-loadout').hide()
                    container.find('tr.info-agility').hide()
                    container.find('tr.info-hull').hide()
                    container.find('tr.info-shields').hide()
                    container.find('tr.info-actions').hide()
                    container.find('tr.info-upgrades').hide()
                    container.find('p.info-maneuvers').hide()
                    container.find('tr.info-energy').hide()
                    container.find('tr.info-attack').hide()
                    container.find('tr.info-attack-turret').hide()
                    container.find('tr.info-attack-bullseye').hide()
                    container.find('tr.info-attack-fullfront').hide()
                    container.find('tr.info-attack-back').hide()
                    container.find('tr.info-attack-doubleturret').hide()
                    container.find('tr.info-charge').hide()
                    container.find('td.info-rangebonus').hide()
                    container.find('tr.info-range').hide()
                    container.find('tr.info-force').hide()
                when 'Damage'
                    container.find('.info-type').text exportObj.translate("types", data.type)
                    container.find('.info-sources.info-data').text (exportObj.translate('sources', source) for source in data.sources).sort().join(', ')
                    container.find('.info-sources').show()

                    if @collection?.counts?
                        addon_count = @collection.counts?['damage']?[data.name] ? 0
                        container.find('.info-collection').text @uitranslation("collectionContentUpgrades", addon_count)
                        container.find('.info-collection').show()
                    else
                        container.find('.info-collection').hide()
                    container.find('.info-name').html """#{if data.display_name then data.display_name else data.name} (#{data.quantity}x)"""
                    
                    container.find('p.info-restrictions').hide()
                    container.find('p.info-text').html (data.text ? '')
                    container.find('p.info-text').show()
                    container.find('p.info-chassis').hide()
                    container.find('tr.info-ship').hide()
                    container.find('tr.info-faction').hide()
                    container.find('tr.info-base').hide()
                    container.find('tr.info-skill').hide()
                    container.find('tr.info-points').hide()
                    container.find('tr.info-loadout').hide()
                    container.find('tr.info-engagement').hide()
                    container.find('tr.info-energy').hide()
                    container.find('tr.info-attack').hide()
                    container.find('tr.info-attack-back').hide()
                    container.find('tr.info-attack-turret').hide()
                    container.find('tr.info-attack-right').hide()
                    container.find('tr.info-attack-left').hide()
                    container.find('tr.info-attack-doubleturret').hide()
                    container.find('tr.info-attack-bullseye').hide()
                    container.find('tr.info-attack-fullfront').hide()
                    container.find('tr.info-charge').hide()
                    container.find('tr.info-range').hide()
                    container.find('td.info-rangebonus').hide()
                    container.find('tr.info-force').hide()     
                    container.find('tr.info-agility').hide()
                    container.find('tr.info-hull').hide()
                    container.find('tr.info-shields').hide()
                    container.find('tr.info-actions').hide()
                    container.find('tr.info-upgrades').hide()
                    container.find('p.info-maneuvers').hide()

            if container != @mobile_tooltip_modal
                container.find('.info-well').show()
                container.find('.intro').hide()
            @tooltip_currently_displaying = data

            # fix card viewer to view, if it is fully visible (it might not be e.g. on mobile devices. In that case keep it on its static position, so you can scroll to see it)
            
            if $(window).width() >= 768
                well = container.find('.info-well')
                if $.isElementInView(well, true)
                    well.css('position','fixed')
                else
                    well.css('position','static')
        
    _randomizerLoopBody: (data) =>
        if data.keep_running
            if @total_points == data.max_points
                # ToDo: Check if we meet the requirement of minimum 3 ships?
                # Ships are done, now start equipping upgrades to them!
                data.keep_running = false
                if @isQuickbuild
                    data.keep_running = false
                    return
                    
                for ship in @ships
                    expensive_slots = []
                    if ship.pilot.loadout? and not ship.pilot.upgrades?
                        while ship.upgrade_points_total < ship.pilot.loadout
                            # we wan't to utilize newly added upgrade slots, so we will check for slots iteratively
                            unused_addons = []
                            for upgrade in ship.upgrades
                                unused_addons.push upgrade unless upgrade.data? or (upgrade.occupied_by? and upgrade.occupied_by != null) or upgrade in expensive_slots
                            if unused_addons.length == 0
                                break # it's fine to not spend all points - otherwise few-slot ships will always receive the same upgrade(s)
                            # select random slot
                            addon = unused_addons[$.randomInt unused_addons.length]
                            # select and equip random upgrade
                            available_upgrades = (upgrade for upgrade in @getAvailableUpgradesIncluding(addon.slot, null, ship, addon,'', @dfl_filter_func, sorted = false) when (exportObj.upgradesById[upgrade.id].sources.intersects(data.allowed_sources) and ((not data.collection_only) or @collection.checkShelf('upgrade', upgrade.name))) and not upgrade.disabled)
                            if available_upgrades.length > 0
                                upgrade =  available_upgrades[$.randomInt available_upgrades.length] 
                                await addon.setById upgrade.id
                            else
                                # that slot has only expensive stuff. ignore it in the future!
                                expensive_slots.push addon
                        
            else if @total_points < data.max_points
                # need to add more ships
                # Add random ship
                # try to find a ship that is cheap enough. If none exist, pick an expensive one and remove a random ship in the next iteration
                available_ships = @getAvailableShipsMatchingAndCheapEnough(data.max_points - @total_points, '', false, data.collection_only)
                if available_ships.length == 0
                    available_ships = @getAvailableShipsMatching('', false, data.collection_only)
                if (available_ships.length > 0) and ((@ships.length < data.ship_limit) or (data.ship_limit == 0))
                    ship_type = available_ships[$.randomInt available_ships.length].name
                    available_pilots = @getAvailablePilotsForShipIncluding(ship_type)
                    if available_pilots.length == 0 
                        # edge case: It might have been a ship selected, that has only unique pilots - which all have been already selected 
                        return
                    pilot = available_pilots[$.randomInt available_pilots.length]
                    if not pilot.disabled and (if @isQuickbuild then exportObj.pilots[exportObj.quickbuildsById[pilot.id].pilot] else exportObj.pilotsById[pilot.id]).sources.intersects(data.allowed_sources) and ((not data.collection_only) or @collection.checkShelf('pilot', (if @isQuickbuild then exportObj.quickbuildsById[pilot.id] else pilot.name)))
                        new_ship = @addShip()
                        new_ship.setPilotById pilot.id

            else
                # need to remove a ship, cause we are too expensive
                @removeShip @ships[$.randomInt @ships.length]
            # continue the "loop"
            window.setTimeout @_makeRandomizerLoopFunc(data), 0
        else
            #console.log "Clearing timer #{data.timer}, iterations=#{data.iterations}, keep_running=#{data.keep_running}"
            # we have to stop randomizing, but should do a final check on our point costs. (in case our last step was adding something expensive)
            while @total_points > data.max_points
                @removeShip @ships[$.randomInt @ships.length]

            if data.fill_zero_pts
                for ship in @ships
                    for addon in ship.upgrades
                        continue unless not (addon.data? or (addon.occupied_by? and addon.occupied_by != null))
                        available_upgrades = (upgrade for upgrade in @getAvailableUpgradesIncluding(addon.slot, null, addon.ship, addon,'', @dfl_filter_func, sorted = false) when (exportObj.upgradesById[upgrade.id].sources.intersects(data.allowed_sources) and (upgrade.points < 1) and ((not data.collection_only) or @collection.checkShelf('upgrade', upgrade.name))))
                        upgrade = if available_upgrades.length > 0 then available_upgrades[$.randomInt available_upgrades.length] else undefined
                        if upgrade and not upgrade.disabled
                            addon.setById upgrade.id
                        
            window.clearTimeout data.timer
            # Update all selectors
            for ship in @ships
                ship.updateSelections()
            @suppress_automatic_new_ship = false
            @addShip()

    _makeRandomizerLoopFunc: (data) =>
        () =>
            @_randomizerLoopBody(data)

    randomSquad: (max_points=200, allowed_sources=null, timeout_ms=1000, ship_limit=0, collection_only=true, fill_zero_pts=false) ->
        @backend_status.fadeOut 'slow'
        @suppress_automatic_new_ship = true
        
        if allowed_sources.length < 1
            allowed_sources = null
        
        # Clear all existing ships
        while @ships.length > 0
            @removeShip @ships[0]
        throw new Error("Ships not emptied") if @ships.length > 0
        data =
            max_points: max_points
            ship_limit: ship_limit
            keep_running: true
            allowed_sources: allowed_sources ? exportObj.expansions
            collection_only: @collection? and (@collection.checks.collectioncheck == "true") and collection_only
            fill_zero_pts: fill_zero_pts
        stopHandler = () =>
            #console.log "*** TIMEOUT *** TIMEOUT *** TIMEOUT ***"
            data.keep_running = false
        data.timer = window.setTimeout stopHandler , timeout_ms
        #console.log "Timer set for #{timeout_ms}ms, timer is #{data.timer}"
        window.setTimeout @_makeRandomizerLoopFunc(data), 0
        @resetCurrentSquad()
        @current_squad.name = @uitranslation('Random Squad')
        @container.trigger 'xwing-backend:squadNameChanged'

    setBackend: (backend) ->
        @backend = backend
        if @waiting_for_backend?
            for meth in @waiting_for_backend
                meth()

    upgrade_effect: (card) ->
        removestext = text = comma = ''
        if card.modifier_func
            statchange =
                attack: 0
                attackf: 0
                attackbull: 0
                attackb: 0
                attackt: 0
                attackl: 0
                attackr: 0
                attackdt: 0
                energy: 0
                agility: 0
                hull: 0
                shields: 0
                force: 0
                actions: []
                maneuvers: [0, 0]
            card.modifier_func(statchange)
            if statchange.attack != 0
                text += comma + "%FRONTARC% (#{statchange.attack})"
                comma = ', '
            if statchange.attackf != 0
                text += comma + "%FULLFRONTARC% (#{statchange.attackf})"
                comma = ', '
            if statchange.attackbull != 0
                text += comma + "%BULLSEYEARC% (#{statchange.attackbull})"
                comma = ', '
            if statchange.attackb != 0
                text += comma + "%REARARC% (#{statchange.attackb})"
                comma = ', '
            if statchange.attackt != 0
                text += comma + "%SINGLETURRETARC% (#{statchange.attackt})"
                comma = ', '
            if statchange.attackl != 0
                text += comma + "%LEFTARC% (#{statchange.attackl})"
                comma = ', '
            if statchange.attackr != 0
                text += comma + "%RIGHTARC% (#{statchange.attackr})"
                comma = ', '
            if statchange.attackdt != 0
                text += comma + "%DOUBLETURRETARC% (#{statchange.attackdt})"
                comma = ', '
            if statchange.energy != 0
                text += comma + "%ENERGY% (#{statchange.energy})"
                comma = ', '
            if statchange.agility != 0
                text += comma + "%AGILITY% (#{statchange.agility})"
                comma = ', '
            if statchange.hull != 0
                text += comma + "%HULL% (#{statchange.hull})"
                comma = ', '
            if statchange.shields != 0
                text += comma + "%SHIELD% (#{statchange.shields})"
                comma = ', '
            if statchange.actions.length > 0
                text += comma + @formatActions(statchange.actions, ", ")
                comma = ', '
        if card.confersAddons
            for addonname in card.confersAddons
                if addonname.slot == "Force" then text += comma + "%FORCEPOWER%" else text += comma + "%#{addonname.slot.toUpperCase().replace(/[^a-z0-9]/gi, '')}%" 
                comma = ', '
        if card.unequips_upgrades
            comma = ''
            for slot in card.unequips_upgrades
                removestext += comma + "%#{slot.toUpperCase().replace(/[^a-z0-9]/gi, '')}%" 
                comma = ', '
        if text != ''
            data = 
                text: "</br><b>#{@uitranslation("adds", text)}</b>"
            if removestext != ''
                data.text += "</br><b>#{@uitranslation("removes", removestext)}</b>"
            return exportObj.fixIcons(data)
        else
            return ''

    restriction_text: (card) ->
        uniquetext = comma = othertext = text = ''
        ignoreShip = false
        standardized = card.standardized?
        if (@isXwa and card.standardizedxwa?) then standardized = card.standardizedxwa
        if card.restrictions? then card_restrictions = card.restrictions
        if (@isXwa and card.restrictionsxwa?) then card_restrictions = card.restrictionsxwa
        if card_restrictions?
            for r in card_restrictions
                switch r[0]
                    when "FactionOrUnique"
                        othertext += comma + exportObj.translate('faction', "#{r[2]}")                
                        uniquetext = exportObj.translate('restrictions', " or Squad Including") + " #{r[1]}"
                    when "Base"
                        for b, index in r
                            if b == "Base" 
                                text += comma
                                continue
                            text += "#{b} "
                            if index < r.length - 1 then text += "or " else text += exportObj.translate('restrictions', "Ship")
                    when "Action"
                        array = [r[1]]
                        text += comma + @formatActions(array,"", [])
                    when "Equipped"
                        text += comma + "%#{r[1].toUpperCase().replace(/[^a-z0-9]/gi, '')}% Equipped"
                    when "Slot"
                        text += comma + exportObj.translate('restrictions', "Extra") + " %#{r[1].toUpperCase().replace(/[^a-z0-9]/gi, '')}%"
                    when "Keyword"
                        text += comma + exportObj.translate('restrictions', "#{r[1]}")
                        ignoreShip = true
                    when "AttackArc"
                        text += comma + "%REARARC%"
                    when "ShieldsGreaterThan"
                        text += comma + "%SHIELD% > #{r[1]}"
                    when "EnergyGreatterThan"
                        text += comma + "%ENERGY% > #{r[1]}"
                    when "InitiativeGreaterThan"
                        text += comma + exportObj.translate('restrictions', "Initiative") + " > #{r[1]}"
                    when "InitiativeLessThan"
                        text += comma + exportObj.translate('restrictions', "Initiative")+ " < #{r[1]}"
                    when "HasForce"
                        text += comma + (if r[1] then "" else "No ") + "%FORCE%"
                    when "AgilityEquals"
                        text += comma + exportObj.translate('restrictions', "Agility") + " = #{r[1]}"
                    when "isUnique"
                        if r[1] == true
                            text += comma + exportObj.translate('restrictions', "Limited")
                        else
                            text += comma + exportObj.translate('restrictions', "Non-Limited")
                    when "Format"
                        text += comma + exportObj.translate('restrictions', "#{r[1]} Ship")
                    when "Faction"
                        othertext += comma + exportObj.translate('faction', "#{r[1]}")
                comma = ', '
        if not card.skill
            if othertext == ''
                if card.faction
                    if card.faction instanceof Array
                        for factionitem in card.faction
                            othertext += comma + exportObj.translate('faction', "#{factionitem}")
                            comma = ' or '
                    else
                        othertext += comma + exportObj.translate('faction', "#{card.faction}")
                    comma = ', '
            if card.ship and ignoreShip == false
                if card.ship instanceof Array
                    for shipname in card.ship
                        othertext += comma + shipname
                        comma = ' or '
                else
                    othertext += comma + card.ship
                comma = ', '
            if card.solitary
                othertext += comma + exportObj.translate('gameterms', "Solitary")
                comma = ', '
            if standardized
                othertext += comma + exportObj.translate('gameterms', "Standardized")
                comma = ', '
        text += othertext + uniquetext
        if text != ''
            data = 
                text: "<i><b>" + exportObj.translate('restrictions', "Restrictions") + ":</b> " + text + "</i>"
            return exportObj.fixIcons(data)
        else
            return ''


    describeSquad: ->
        if @getNotes().trim() == '' then  ((ship.pilot.name for ship in @ships when ship.pilot?).join ', ') else @getNotes()

    listCards: ->
        card_obj = {}
        for ship in @ships
            if ship.pilot?
                card_obj[ship.pilot.name] = null
                for upgrade in ship.upgrades
                    card_obj[upgrade.data.name] = null if upgrade.data?
        return Object.keys(card_obj).sort()

    getNotes: ->
        @notes.val()

    getTag: ->
        @tag.val()
        
    getObstacles: ->
        @current_obstacles

    isSquadPossibleWithCollection: ->
        # If the collection is uninitialized or empty, don't actually check it.
        if Object.keys(@collection?.expansions ? {}).length == 0
            # console.log "collection not ready or is empty"
            return [true, []]
        else if @collection?.checks.collectioncheck != "true"
            # console.log "collection check not enabled"
            return [true, []]
        @collection.reset()
        validity = true
        missingStuff = []
        for ship in @ships
            if ship.pilot?
                # Try to get both the physical model and the pilot card.
                ship_is_available = @collection.use('ship', ship.pilot.ship)
                pilot_is_available = @collection.use('pilot', ship.pilot.name)
                # console.log "#{@faction}: Ship #{ship.pilot.ship} available: #{ship_is_available}"
                # console.log "#{@faction}: Pilot #{ship.pilot.name} available: #{pilot_is_available}"
                validity = false unless ship_is_available and pilot_is_available
                missingStuff.push ship.data unless ship_is_available
                missingStuff.push ship.pilot unless pilot_is_available
                if not ship.pilot.upgrades?
                    for upgrade in ship.upgrades
                        if upgrade.data?
                            upgrade_is_available = @collection.use('upgrade', upgrade.data.name)
                            # console.log "#{@faction}: Upgrade #{upgrade.data.name} available: #{upgrade_is_available}"
                            validity = false unless upgrade_is_available or upgrade.data.standard?
                            missingStuff.push upgrade.data unless upgrade_is_available or upgrade.data.standard?
        [validity, missingStuff]

    checkCollection: ->
        # console.log "#{@faction}: Checking validity of squad against collection..."
        if @collection?
            [squadPossible, missingStuff] = @isSquadPossibleWithCollection()
            @collection_invalid_container.toggleClass 'd-none', squadPossible
            @collection_invalid_container.on 'mouseover', (e) =>
                @showTooltip 'MissingStuff', missingStuff

    toXWS: ->
        # Often you will want JSON.stringify(builder.toXWS())
        versioninfo = "09/06/2024"
        rules = "AMG"
        if @isXwa
            versioninfo = "R2"
            rules = "XWA"

        xws =
            description: @getNotes()
            faction: exportObj.toXWSFaction[@faction]
            name: @current_squad.name
            pilots: []
            points: @total_points
            vendor:
                yasb:
                    builder: 'YASB - X-Wing 2.5'
                    builder_url: window.location.href.split('?')[0]
                    link: @getPermaLink()
            version: versioninfo
            ruleset: rules
            # there is no point to have this version identifier, if we never actually increase it, right?

        for ship in @ships
            if ship.pilot?
                xws.pilots.push ship.toXWS()

        # Associate multisection ships
        # This maps id to list of pilots it comprises
        multisection_id_to_pilots = {}
        last_id = 0
        unmatched = (pilot for pilot in xws.pilots when pilot.multisection?)
        for _ in [0...(unmatched.length ** 2)]
            break if unmatched.length == 0
            # console.log "Top of loop, unmatched: #{m.name for m in unmatched}"
            unmatched_pilot = unmatched.shift()
            unmatched_pilot.multisection_id ?= last_id++
            multisection_id_to_pilots[unmatched_pilot.multisection_id] ?= [unmatched_pilot]
            break if unmatched.length == 0
            # console.log "Finding matches for #{unmatched_pilot.name} (assigned id=#{unmatched_pilot.multisection_id})"
            matches = []
            for candidate in unmatched
                # console.log "-> examine #{candidate.name}"
                if unmatched_pilot.name in candidate.multisection
                    matches.push candidate
                    unmatched_pilot.multisection.removeItem candidate.name
                    candidate.multisection.removeItem unmatched_pilot.name
                    candidate.multisection_id = unmatched_pilot.multisection_id
                    # console.log "-> MATCH FOUND #{candidate.name}, assigned id=#{candidate.multisection_id}"
                    multisection_id_to_pilots[candidate.multisection_id].push candidate
                    if unmatched_pilot.multisection.length == 0
                        # console.log "-> No more sections to match for #{unmatched_pilot.name}"
                        break
            for match in matches
                if match.multisection.length == 0
                    # console.log "Dequeue #{match.name} since it has no more sections to match"
                    unmatched.removeItem match

        for pilot in xws.pilots
            delete pilot.multisection if pilot.multisection?

        obstacles = @getObstacles()
        if obstacles? and obstacles.length > 0
            xws.obstacles = obstacles

        xws

    toMinimalXWS: ->
        # Just what's necessary
        xws = @toXWS()

        # Keep mandatory stuff only
        for own k, v of xws
            delete xws[k] unless k in ['faction', 'pilots', 'version']

        for own k, v of xws.pilots
            delete xws[k] unless k in ['id', 'upgrades', 'multisection_id']

        xws

    loadFromXWS: (xws, cb) ->
        success = null
        error = null
        
        if xws.version?
            version_list = (parseInt x for x in xws.version.split('.'))
        else
            version_list = [0,2] # Version tag is optional, so let's just assume it is some 2.0 xws if no version is given

        switch
            # Not doing backward compatibility pre-1.x
            when version_list > [0, 1] or xws.ruleset == 'XWA'
                xws_faction = exportObj.fromXWSFaction[xws.faction]

                if @faction != xws_faction
                        throw new Error("Attempted to load XWS for #{xws.faction} but builder is #{@faction}")

                if xws.name?
                    @current_squad.name = xws.name
                if xws.description?
                    @notes.val xws.description

                if xws.obstacles?
                    @current_squad.additional_data.obstacles = xws.obstacles

                @suppress_automatic_new_ship = true
                @removeAllShips()

                success = true
                error = ""

                # we use our current gamemode as default, but switch to standard if we are in XWA but the loaded xws specifies AMG or vice versa
                if @isStandard then gamemode = 'h' else if @isEpic then gamemode = 'e' else if @isXwa then gamemode = 'b' else gamemode = 's'
                if xws.ruleset? and xws.ruleset == 'XWA' then gamemode = 'b' else if xws.ruleset? and xws.ruleset == 'AMG' and gamemode == 'b' then gamemode = 'h'
                serialized_squad = ""

                for pilot in xws.pilots
                    new_ship = @addShip()
                    # we add some backward compatibility here, to allow imports from Launch Bay Next Squad Builder
                    # According to xws-spec, for 2nd edition we use id instead of name
                    # however, we will accept a name instead of an id as well.
                    
                    if pilot.id
                        pilotxws = pilot.id
                    else if pilot.name
                        pilotxws = pilot.name
                    else
                        success = false
                        error = "Pilot without identifier"
                        break

                    # add pilot id
                    if exportObj.pilotsByFactionXWS[xws_faction][pilotxws]? 
                        serialized_squad +=  exportObj.pilotsByFactionXWS[xws_faction][pilotxws][0].id
                    else if exportObj.pilotsByUniqueName[pilotxws] and exportObj.pilotsByUniqueName[pilotxws].length == 1
                        serialized_squad +=  exportObj.pilotsByUniqueName[pilotxws][0].id
                    
                    else
                        for key, possible_pilots of exportObj.pilotsByUniqueName
                            for possible_pilot in possible_pilots
                                if (possible_pilot.xws and possible_pilot.xws == pilotxws) or (not possible_pilot.xws and key == pilotxws)
                                    serialized_squad += possible_pilot.id
                                    break

                    # game mode version check: pilot and ship
                    if not exportObj.standardCheck(pilot, true) and gamemode == 'h'
                        gamemode = 's'

                    serialized_squad += "X"

                    # add upgrade ids
                    # Turn all the upgrades into a flat list so we can keep trying to add them
                    addons = []
                    for upgrade_type, upgrade_canonicals of pilot.upgrades ? {}
                        for upgrade_canonical in upgrade_canonicals
                            # console.log upgrade_type, upgrade_canonical
                            slot = null
                            slot = exportObj.fromXWSUpgrade[upgrade_type] ? upgrade_type.capitalize()
                            if upgrade_canonical?
                                upgrade = exportObj.upgradesBySlotXWSName[slot][upgrade_canonical] ?= exportObj.upgradesBySlotCanonicalName[slot][upgrade_canonical]
                                if not upgrade?
                                    console.log("Failed to load xws upgrade: " + upgrade_canonical)
                                    error += "Skipped upgrade " + upgrade_canonical
                                    success = false
                                    continue
                                serialized_squad += upgrade.id
                                serialized_squad += "W"
                                if not exportObj.standardCheck(upgrade, true) and gamemode == 'h'
                                    gamemode = 's'
                    serialized_squad += "XY"

                serialized_squad_intro = "v9Z" + gamemode + "Z20Z" # serialization v9, extended squad, 20 points
                # serialization schema SHIPID:UPGRADEID,UPGRADEID,...,UPGRADEID:;SHIPID:UPGRADEID,...

                serialized_squad = serialized_squad_intro + serialized_squad

                afterLoad = () =>
                    @current_squad.dirty = true
                    @container.trigger 'xwing-backend:squadNameChanged'
                    @container.trigger 'xwing-backend:squadDirtinessChanged'
                    cb
                        success: success
                        error: error

                @loadFromSerialized(serialized_squad, afterLoad)

            else
                success = false
                error = "Unsupported XWS version"
                cb success, error


        cb
            success: success
            error: error

class Ship
    constructor: (args) ->
        # args
        @builder = args.builder
        @container = args.container

        # internal state
        @pilot = null
        @data = null # ship data
        @quickbuildId = -1
        @linkedShip = null # some quickbuilds contain two ships, this variable may reference a Ship beeing part of the same quickbuild card
        @primary = true # only the primary ship of a linked ship pair will contribute points and serialization id
        @upgrades = []
        @upgrade_points_total = 0
        @wingmates = [] # stores wingmates (quickbuild stuff only) 
        @destroystate = 0
        @uitranslation = @builder.uitranslation
        @usesxwaSlots = false # flag if we use xwa slots. This is needed, if we switch betwen XWA/AMG points to rebuild the pilot if the slots change

        @setupUI()

    destroy: (cb) ->
        @resetPilot()
        @resetAddons()
        @teardownUI()
        idx = @builder.ships.indexOf this
        if idx < 0
            throw new Error("Ship not registered with builder")
        @builder.ships.splice idx, 1
        # remove all wingmates, if we are wingleader
        if @wingmates.length > 0
            @setWingmates(0)
        # check if there is a linked ship
        if @linkedShip != null
            # remove us from the wing, if we are part of a wing
            if @linkedShip.wingmates?.length > 0 and this in @linkedShip.wingmates
                @linkedShip.removeFromWing(this)
            # we are not part of a wing, so we just want to also remove the linked ship
            else
                # unlink us from the linked ship, so we are not in a infinite recursive trap (it will otherwise attempt to remove us)
                @linkedShip.linkedShip = null
                await new Promise((resolve,reject) =>@builder.removeShip @linkedShip, resolve)
        cb()

    copyFrom: (other) ->
        throw new Error("Cannot copy from self") if other is this
        #console.log "Attempt to copy #{other?.pilot?.name}"
        return unless other.pilot? and other.data?
        #console.log "Setting pilot to ID=#{other.pilot.id}"
        if @builder.isQuickbuild
            # check if pilot is unique. In that case the whole ship may not be copied, but the cheapest alternative will be selected
            no_uniques_involved = not (other.pilot.unique or (other.pilot.max_per_squad? and @builder.countPilots(other.pilot.canonical_name) >= other.pilot.max_per_squad))
            if no_uniques_involved
                # also check all upgrades
                for upgrade in other.upgrades
                    if (upgrade.data?.unique? and upgrade.data.unique) or (upgrade.data?.max_per_squad? and @builder.countUpgrades(upgrade.data.canonical_name) >= upgrade.data.max_per_squad) or upgrade.data?.solitary?
                        no_uniques_involved = false                
            if no_uniques_involved
                # still no uniques, so we can copy that ship as is
                @setPilotById other.quickbuildId
            else
                # try to select another pilot for the same ship instead
                available_pilots = (pilot_data for pilot_data in @builder.getAvailablePilotsForShipIncluding(other.data.name) when not pilot_data.disabled)
                if available_pilots.length > 0
                    @setPilotById available_pilots[0].id, true
                else
                    return
        else 
            if other.pilot.unique or (other.pilot.max_per_squad? and @builder.countPilots(other.pilot.canonical_name) >= other.pilot.max_per_squad)
                # Look for cheapest generic or available unique, otherwise do nothing
                available_pilots = (pilot_data for pilot_data in @builder.getAvailablePilotsForShipIncluding(other.data.name) when not pilot_data.disabled)
                if available_pilots.length > 0
                    await @setPilotById available_pilots[0].id, true

                else
                    return
            else
                await @setPilotById other.pilot.id, true

            # filter out upgrades that can be copied
            other_upgrades = {}
            for upgrade in other.upgrades
                if upgrade?.data? and not upgrade.isStandardized() and not upgrade.data.standard? and not upgrade.data.unique and ((not upgrade.data.max_per_squad?) or @builder.countUpgrades(upgrade.data.canonical_name) < upgrade.data.max_per_squad)
                    other_upgrades[upgrade.slot] ?= []
                    other_upgrades[upgrade.slot].push upgrade
            # set them aside any upgrades that don't fill requirements due to additional slots and then attempt to fill them
            delayed_upgrades = {}
            for upgrade in @upgrades
                if not upgrade.isOccupied() # an earlier set double-slot upgrade may already use this slot
                    other_upgrade = (other_upgrades[upgrade.slot] ? []).shift()
                    if other_upgrade?
                        await upgrade.setById other_upgrade.data.id
                        # it would be cool if upgrade.setById would return whether it succeeded (as promise), so we could attempt to add all
                        # upgrades, wait for all promises to resolve, and then retry the rejected upgrades. Instead, we wait for each upgrade individually.
                        if not upgrade.lastSetValid
                            delayed_upgrades[other_upgrade.data.id] = upgrade
            for id, upgrade of delayed_upgrades
                upgrade.setById id
            # Do one final pass on upgrades to see if there are any more upgrades we can assign
            for upgrade in @upgrades
                if not upgrade.isOccupied()
                    other_upgrade = (other_upgrades[upgrade.slot] ? []).shift()
                    if other_upgrade?
                        upgrade.setById other_upgrade.data.id
            
            @addStandardizedUpgrades()
        @updateSelections()
        @builder.container.trigger 'xwing:pointsUpdated'
        @builder.current_squad.dirty = true
        @builder.container.trigger 'xwing-backend:squadDirtinessChanged'

    setShipType: (ship_type) ->
        @pilot_selector.data('select2').container.show()
        if ship_type != @pilot?.ship
            if not @builder.isQuickbuild
                @setPilot (exportObj.pilotsById[result.id] for result in @builder.getAvailablePilotsForShipIncluding(ship_type) when ((not exportObj.pilotsById[result.id].restriction_func? or exportObj.pilotsById[result.id].restriction_func(@)) and not (exportObj.pilotsById[result.id] in @builder.uniques_in_use.Pilot)))[0]
            else
                # get the first available pilot
                quickbuild_id = (result.id for result in @builder.getAvailablePilotsForShipIncluding(ship_type) when not result.disabled)[0]
                @setPilotById quickbuild_id
                
        @checkPilotSelectorQueryModal()
                
        # Clear ship background class
        for cls in @row.attr('class').split(/\s+/)
            if cls.indexOf('ship-') == 0
                @row.removeClass cls

        # Show delete button
        @remove_button.fadeIn 'fast'
        @copy_button.fadeIn 'fast'
        if @builder.show_points_destroyed == true
            @points_destroyed_button.fadeIn 'fast'

        @row.addClass "ship-#{ship_type.toLowerCase().replace(/[^a-z0-9]/gi, '')}"

        @builder.container.trigger 'xwing:shipUpdated'

    setPilotById: (id, noautoequip = false) ->
        #sets pilot of this ship according to given id. Id might be pilotId or quickbuildId depending on mode. 
        if not @builder.isQuickbuild
            @setPilot exportObj.pilotsById[parseInt id], noautoequip
        else
            if id != @quickbuildId
                @wingmate_selector.parent().hide()
                if @wingmates? and @wingmates.length > 0
                    # remove any wingmates, as the wing leader was just removed from the list
                    @setWingmates(0)
                    # @linkedShip = null the ghost hera has wingmates and a linked phantom. We can't assume that we are done here...
                @quickbuildId = id
                @builder.current_squad.dirty = true
                @resetPilot()
                @resetAddons()
                if id? and id > -1
                    quickbuild = exportObj.quickbuildsById[parseInt id]
                    new_pilot = exportObj.pilots[quickbuild.pilot]
                    @data = exportObj.ships[quickbuild.ship]
                    @builder.isUpdatingPoints = true # prevents unneccesary validations while still adding stuff
                    if new_pilot?.unique?
                        await new Promise((resolve,reject) => @builder.container.trigger 'xwing:claimUnique', [ new_pilot, 'Pilot', resolve ])
                    @pilot = new_pilot
                    @setupAddons() if @pilot?
                    @copy_button.show()
                    @setShipType @pilot.ship

                    # if this card contains more than one ship, make sure the other one is added as well
                    if quickbuild.wingmate? && not @linkedShip?
                        # try to join wingleader, if we have not been created by him
                        for ship in @builder.ships
                            if ship.quickbuildId == quickbuild.linkedId
                                # found our leader. join him.
                                ship.joinWing(this)
                                @linkedShip = ship
                                @primary = false
                                @builder.isUpdatingPoints = false
                                @builder.container.trigger 'xwing:pointsUpdated'
                                @builder.container.trigger 'xwing-backend:squadDirtinessChanged'
                                return # we are done.
                    if @linkedShip
                        # we are already linked to some other ship
                        if quickbuild.linkedId? 
                            # we will stay linked to another ship, so just set the linked one to an new pilot es well
                            @linkedShip.setPilotById quickbuild.linkedId
                            @linkedShip.primary = false unless quickbuild.wingmate?
                        else
                            # take care of associated ship
                            if @linkedShip.wingmates?.length > 0
                                # we are no longer part of a wing
                                @linkedShip.removeFromWing(this)
                            else
                                # we are no longer part of a linked pair, so the linked ship should be removed
                                @linkedShip.linkedShip = null
                                await new Promise((resolve,reject) => @builder.removeShip @linkedShip, resolve)
                            @linkedShip = null
                    else if quickbuild.linkedId?
                        # we nare not already linked to another ship, but need one. Let's set one up
                        @linkedShip = @builder.ships.slice(-1)[0]
                        # during squad building there is an empty ship at the bottom, use that one and add a new empty one. 
                        # during squad loading there is no empty ship at the bottom, so we just create a new one and use it
                        if @linkedShip.data != null
                            @linkedShip = @builder.addShip()
                        else 
                            @builder.addShip()
                        @linkedShip.linkedShip = this
                        @linkedShip.setPilotById quickbuild.linkedId
                        # for pairs the first selected ship is master, so as we have been created first, we set the other ship to false
                        # for wings the wingleader is always master, so we don't set the other ship to false, if we are just a wingmate
                        @linkedShip.primary = false unless quickbuild.wingmate?
                    @primary = !quickbuild.wingmate?
                    if quickbuild?.wingleader? 
                        @wingmate_selector.parent().show()
                        @wingmate_selector.val quickbuild.wingmates[0]
                        @wingmate_selector.attr "min", quickbuild.wingmates[0]
                        @wingmate_selector.attr "max", quickbuild.wingmates[quickbuild.wingmates.length - 1]
                        @setWingmates quickbuild.wingmates[0]
                    @builder.isUpdatingPoints = false
                    @builder.container.trigger 'xwing:pointsUpdated'
                else
                    @copy_button.hide()
                @row.removeClass('unsortable')
                @builder.container.trigger 'xwing:pointsUpdated'
                @builder.container.trigger 'xwing-backend:squadDirtinessChanged'

    addStandardizedUpgrades: ->
        if @hasFixedUpgrades
            return # standard ships bypass
        idx = @builder.standard_list['Ship'].indexOf @data?.name
        if idx > -1
            upgrade_to_be_equipped = @builder.standard_list['Upgrade'][idx]
            restrictions = (if upgrade_to_be_equipped.restrictions then upgrade_to_be_equipped.restrictions else undefined)
            # first check if we already have that upgrade equipped. No need to do anything if we do. 
            for upgrade in @upgrades
                if upgrade.data?.name == upgrade_to_be_equipped.name
                    return
            # now look for empty slots that could be equipped
            for upgrade in @upgrades
                if exportObj.slotsMatching(upgrade.slot, @builder.standard_list['Upgrade'][idx].slot)
                    if @restriction_check(restrictions,upgrade) and not upgrade.data?
                        upgrade.setData upgrade_to_be_equipped
                        return

    addToStandardizedList: (upgrade_data) ->
        # check first if standard combo exists and return if it does
        idx = @builder.standard_list['Ship'].indexOf @data.name
        if idx > -1
            if @builder.standard_list['Upgrade'][idx]?.name == upgrade_data.name
                return
        @builder.standard_list['Upgrade'].push upgrade_data
        @builder.standard_list['Ship'].push @data.name

    removeStandardizedList: (upgrade_data) ->
        # removes the ship upgrade combo from the stanard list array
        idx = @builder.standard_list['Ship'].indexOf @data.name
        if idx > -1
            if @builder.standard_list['Upgrade'][idx]?.name == upgrade_data.name
                @builder.standard_list['Upgrade'].splice idx,1 
                @builder.standard_list['Ship'].splice idx,1
                
                # now remove all upgrades of the same name
                for ship in @builder.ships
                    if ship.data?.name == @data.name and ship != this
                        for upgrade in ship.upgrades
                            if upgrade.data?.name == upgrade_data.name
                                upgrade.setData null
                                break

    checkStandardizedList: (ship_name) ->
        # check first if standard combo exists and return if it does
        idx = @builder.standard_list['Ship'].indexOf ship_name
        if idx > -1
            if @builder.standard_list['Upgrade'][idx]?.name?
                return @builder.standard_list['Upgrade'][idx]
        else
            return undefined

    setPilot: (new_pilot, noautoequip = false) ->
        # don't call this method directly, unless you know what you do. Use setPilotById for proper quickbuild handling

        if new_pilot != @pilot or (@builder.isXwa and not @usesxwaSlots and @pilot.slotsxwa?) or (@usesxwaSlots and not @builder.isXwa)
            @builder.current_squad.dirty = true
            same_ship = @pilot? and new_pilot?.ship == @pilot.ship
            old_upgrades = {}
            if same_ship and not @pilot.upgrades?
                # track addons and try to reassign them
                for upgrade in @upgrades
                    if upgrade?.data?
                        old_upgrades[upgrade.slot] ?= []
                        old_upgrades[upgrade.slot].push upgrade.data.id
            await @resetPilot()
            await @resetAddons()
            if new_pilot?
                @data = exportObj.ships[new_pilot?.ship]
                if new_pilot?.unique?
                    await new Promise((resolve,reject) => @builder.container.trigger 'xwing:claimUnique', [ new_pilot, 'Pilot', resolve])
                @pilot = new_pilot
                @setupAddons() if @pilot?
                @copy_button.show()
                @setShipType @pilot.ship
                if (@pilot.autoequip? or (exportObj.ships[@pilot.ship].autoequip? and not same_ship)) and not noautoequip
                    autoequip = (@pilot.autoequip ? []).concat(exportObj.ships[@pilot.ship].autoequip ? [])
                    for upgrade_name in autoequip
                        auto_equip_upgrade = exportObj.upgrades[upgrade_name]
                        for upgrade in @upgrades
                            if exportObj.slotsMatching(upgrade.slot, auto_equip_upgrade.slot)
                                upgrade.setData auto_equip_upgrade
                if same_ship and not @pilot.upgrades?
                    # two cycles, in case an old upgrade is adding slots that are required for other old upgrades
                    for _ in [1..2]
                        delayed_upgrades = {}
                        for upgrade in @upgrades
                            # check if there exits old upgrades for this slot - if so, try to add the first of them
                            old_upgrade = (old_upgrades[upgrade.slot] ? []).shift()
                            if old_upgrade?
                                await upgrade.setById old_upgrade
                                if not upgrade.lastSetValid
                                    # failed to add an upgrade, even though the required slot was there - retry later
                                    # perhaps another card is providing an required restriction (e.g. an action)
                                    delayed_upgrades[old_upgrade] = upgrade
                        for id, upgrade of delayed_upgrades
                            upgrade.setById id
                        # last check for standardized
                    # see if ship is supposed to be standardized
                    standard_upgrade_to_check = @checkStandardizedList(@pilot.ship)
                    standard_check = false
                    for upgrade in @upgrades
                        if standard_upgrade_to_check? and (upgrade?.data?.name? and (upgrade.data.name == standard_upgrade_to_check.name))
                            standard_check = true                         
                    if standard_upgrade_to_check? and (standard_check == false)
                        @removeStandardizedList(standard_upgrade_to_check)

            else
                @copy_button.hide()
            @row.removeClass('unsortable')
            @builder.container.trigger 'xwing:pointsUpdated'
            @builder.container.trigger 'xwing-backend:squadDirtinessChanged'

    resetPilot: ->
        if @pilot?.unique?
            await new Promise((resolve,reject) => @builder.container.trigger 'xwing:releaseUnique', [ @pilot, 'Pilot', resolve ])
        @pilot = null

    setupAddons: ->
        if not @builder.isQuickbuild
            if @pilot.upgrades?
                @hasFixedUpgrades = true
                @usesxwaSlots = false
                for upgrade_name in @pilot.upgrades ? []
                    upgrade_data = exportObj.upgrades[upgrade_name]
                    if not upgrade_data?
                        console.log("Unknown Upgrade: " + upgrade_name)
                        continue
                    upgrade = new exportObj.QuickbuildUpgrade
                        ship: this
                        container: @addon_container
                        slot: upgrade_data.slot
                        upgrade: upgrade_data
                    upgrade.setData upgrade_data
                    @upgrades.push upgrade
            else
                @hasFixedUpgrades = false
                if (@builder.isXwa and @pilot.slotsxwa?) 
                    pilotslots = @pilot.slotsxwa 
                    @usesxwaSlots = true
                else 
                    @usesxwaSlots = false
                    pilotslots = @pilot.slots

                for slot in pilotslots ? []
                    @upgrades.push new exportObj.Upgrade
                        ship: this
                        container: @addon_container
                        slot: slot
        else 
            # Upgrades from quickbuild
            for upgrade_name in exportObj.quickbuildsById[@quickbuildId].upgrades ? []
                upgrade_data = exportObj.upgrades[upgrade_name]
                if not upgrade_data?
                    console.log("Unknown Upgrade: " + upgrade_name)
                    continue
                upgrade = new exportObj.QuickbuildUpgrade
                    ship: this
                    container: @addon_container
                    slot: upgrade_data.slot
                    upgrade: upgrade_data
                upgrade.setData upgrade_data
                @upgrades.push upgrade

    resetAddons: ->
        upgrades_destroyed = []
        for upgrade in @upgrades
                upgrades_destroyed.push(new Promise((resolve,reject) => upgrade.destroy resolve))  if upgrade?
        Promise.all(upgrades_destroyed).then(@upgrades = [])


    getPoints: ->
        if not @builder.isQuickbuild
            if @pilot?
                effective_stats = @effectiveStats()
                points = effective_stats?.points
                loadout = effective_stats?.loadout

            else
                points = 0
                loadout = 0
            @points_container.find('div').text "#{points}"
            @points_container.find('.upgrade-points').text if @pilot?.loadout? then "(#{@upgrade_points_total}/#{loadout})" else ""
            if points > 0
                @points_container.fadeTo 'fast', 1
            else
                @points_container.fadeTo 0, 0
            points
        else    
            quickbuild = exportObj.quickbuildsById[@quickbuildId]
            threat = if @primary then quickbuild?.threat ? 0 else 0 
            if quickbuild?.wingleader?
                threat = quickbuild.threat[quickbuild.wingmates.indexOf(@wingmates.length)]
            @points_container.find('span').text threat
            if threat > 0
                @points_container.fadeTo 'fast', 1
            else
                @points_container.fadeTo 0, 0
            threat

    setWingmates: (wingmates) ->
        # creates/destroys wingmates to match number given as argument
        # todo: Check if number is valid for this quickbuild wing?
        if @wingmates?.length == wingmates
            # nothing to do, we already have correct number of wingmates. 
            return
        if !@wingmates? || @wingmates.length == 0
            # if no wingmates are set yet, create an empty list
            @wingmates = []
        quickbuild = exportObj.quickbuildsById[@quickbuildId]
        while @wingmates.length < wingmates 
            # create more wingmates
            newMate = @builder.ships.slice(-1)[0]
            # during squad building there is an empty ship at the bottom, use that one and add a new empty one. 
            # during squad loading there is no empty ship at the bottom, so we just create a new one and use it
            if newMate.data != null
                newMate = @builder.addShip()
            else 
                @builder.addShip()
            newMate.linkedShip = this # link new mate to us
            @wingmates.push(newMate)
            newMate.setPilotById quickbuild.wingmateId
            # for pairs the first selected ship is master, so as we have been created first, we set the other ship to false
            # for wings the wingleader is always master, so we don't set the other ship to false, if we are just a wingmate
            newMate.primary = false
            @primary = true # he should not try to steal our primary position, as he is aware of beeing not squad leader, but in case he's not just set it. 
        while @wingmates.length > wingmates
            # destroy wingmates
            dyingMate = @wingmates.pop()
            dyingMate.linkedShip = null # prevent the mate from killing us
            await new Promise((resolve,reject) => @builder.removeShip dyingMate, resolve)
        @wingmate_selector.val wingmates

    removeFromWing: (ship) ->
        # remove requested ship from wing
        @wingmates.removeItem(ship)
        # check if the wing is still valid, otherwise destroy it. 
        quickbuild = exportObj.quickbuildsById[@quickbuildId]
        if !(@wingmates.length in quickbuild.wingmates)
            @destroy $.noop
        @wingmate_selector.val @wingmates.length

    joinWing: (ship) ->
        # remove requested ship from wing
        @wingmates.push(ship)
        # check if the wing is still valid, otherwise destroy the added ship
        quickbuild = exportObj.quickbuildsById[@quickbuildId]
        if !(@wingmates.length in quickbuild.wingmates)
            ship.destroy $.noop
            @removeFromWing(ship)
        @wingmate_selector.val @wingmates.length


    updateSelections: ->
        if @pilot?
            @ship_selector.select2 'data',
                id: @pilot.ship
                text: if exportObj.ships[@pilot.ship].display_name then exportObj.ships[@pilot.ship].display_name else @pilot.ship
                chassis: if exportObj.ships[@pilot.ship].chassis then exportObj.ships[@pilot.ship].chassis else ""
                xws: exportObj.ships[@pilot.ship].name.canonicalize()
                icon: if exportObj.ships[@pilot.ship].icon then exportObj.ships[@pilot.ship].icon else exportObj.ships[@pilot.ship].name.canonicalize()
            @pilot_selector.select2 'data',
                id: @pilot.id
                text: "#{if exportObj.settings?.initiative_prefix? and exportObj.settings.initiative_prefix then @pilot.skill + ' - ' else ''}#{if @pilot.display_name then @pilot.display_name else @pilot.name}#{if @quickbuildId != -1 then exportObj.quickbuildsById[@quickbuildId].suffix else ""} (#{if @quickbuildId != -1 then (if @primary then exportObj.quickbuildsById[@quickbuildId].threat else 0) else (if (@builder.isXwa and @pilot.pointsxwa?) then @pilot.pointsxwa else @pilot.points)}#{if (@quickbuildId != -1 or not @pilot.loadout?) then "" else (if @builder.isXwa and @pilot.loadoutxwa? then "/#{@pilot.loadoutxwa}" else "/#{@pilot.loadout}")})"
                chassis: if @pilot.chassis? then @pilot.chassis else ""
            @pilot_selector.data('select2').container.show()
            for upgrade in @upgrades
                points = upgrade.getPoints()
                upgrade.updateSelection points
        else
            @pilot_selector.select2 'data', null
            #@pilot_selector.data('select2').container.toggle(@ship_selector.val() != '')
            
    checkPilotSelectorQueryModal: ->    
        if $(window).width() >= 768
            @pilot_query_modal.hide()
        else 
            if @pilot then @pilot_query_modal.show()

    setupUI: ->
        @row = $ document.createElement 'DIV'
        @row.addClass 'row ship mb-5 mb-sm-0 unsortable'
        @row.insertBefore @builder.notes_container

        @row.append $.trim """
            <div class="col-md-3">
                <div class="form-group d-flex">
                    <input class="ship-selector-container" type="hidden"></input>
                    <div class="d-block d-md-none input-group-append">
                        <button class="btn btn-secondary ship-query-modal"><i class="fas fa-question"></i></button>
                    </div>
                <br />
                </div>
                <div class="form-group d-flex">
                    <input type="hidden" class="pilot-selector-container"></input>
                    <div class="d-block d-md-none input-group-append">
                        <button class="btn btn-secondary pilot-query-modal"><i class="fas fa-question"></i></button>
                    <br />
                    </div>
                </div>
                <label class="wingmate-label">
                #{@uitranslation("Wingmates")}: 
                    <input type="number" class="wingmate-selector"></input>
                </label>
            </div>
            <div class="col-md-1 points-display-container">
                 <div></div>
                 <div class="upgrade-points"></div>
            </div>
            <div class="col-md-6 addon-container">  </div>
            <div class="col-md-2 button-container">
                <button class="btn btn-danger remove-pilot side-button"><span class="d-none d-sm-block" data-toggle="tooltip" title="#{@uitranslation("Remove Pilot")}"><i class="fa fa-times"></i></span><span class="d-block d-sm-none"> #{@uitranslation("Remove Pilot")}</span></button>
                <button class="btn btn-light copy-pilot side-button"><span class="d-none d-sm-block" data-toggle="tooltip" title="#{@uitranslation("Clone Pilot")}"><i class="far fa-copy"></i></span><span class="d-block d-sm-none"> #{@uitranslation("Clone Pilot")}</span></button>
                <button class="btn btn-light points-destroyed side-button" points-state"><span class="d-none d-sm-block destroyed-type" data-toggle="tooltip" title="#{@uitranslation("Points Destroyed")}"><i class="fas fa-circle"></i></i></span><span class="d-block d-sm-none destroyed-type-mobile"> #{@uitranslation("Undamaged")}</span></button>
            </div>
        """
        @row.find('.button-container span').tooltip()

        @ship_selector = $ @row.find('input.ship-selector-container')
        @pilot_selector = $ @row.find('input.pilot-selector-container')
        @wingmate_selector = $ @row.find('input.wingmate-selector')
        @ship_query_modal = $ @row.find('button.ship-query-modal')
        @pilot_query_modal = $ @row.find('button.pilot-query-modal')
        
        
        @ship_query_modal.click (e) =>
            if @pilot
                @builder.showTooltip 'Ship', exportObj.ships[@pilot.ship], null, @builder.mobile_tooltip_modal, true
                @builder.mobile_tooltip_modal.modal 'show'
                
        @pilot_query_modal.click (e) =>
            if @pilot
                @builder.showTooltip 'Pilot', @pilot, (@ if @pilot), @builder.mobile_tooltip_modal, true
                @builder.mobile_tooltip_modal.modal 'show'

            
        shipResultFormatter = (object, container, query) ->
            return """<i class="xwing-miniatures-ship xwing-miniatures-ship-#{object.icon}"></i> #{object.text}"""

        shipSelectionFormatter = (object, container) ->
            return """<i class="xwing-miniatures-ship xwing-miniatures-ship-#{object.icon}"></i> #{object.text}"""
            
        @ship_selector.select2
            width: '100%'
            placeholder: exportObj.translate 'ui', 'shipSelectorPlaceholder'
            query: (query) =>
                data = {results: []}
                data.results = @builder.getAvailableShipsMatching(query.term)
                query.callback(data)
            minimumResultsForSearch: if $.isMobile() then -1 else 0
            formatResultCssClass: (obj) =>
                if @builder.collection? and (@builder.collection.checks.collectioncheck == "true")
                    not_in_collection = false
                    if @pilot? and obj.id == exportObj.ships[@pilot.ship].id
                        # Currently selected ship; mark as not in collection if it's neither
                        # on the shelf nor on the table
                        unless (@builder.collection.checkShelf('ship', obj.name) or @builder.collection.checkTable('pilot', obj.name))
                            not_in_collection = true
                    else
                        # Not currently selected; check shelf only
                        not_in_collection = not @builder.collection.checkShelf('ship', obj.name)
                    if not_in_collection then 'select2-result-not-in-collection' else ''
                else
                    ''
            formatResult: shipResultFormatter
            formatSelection: shipResultFormatter

        @ship_selector.on 'select2-focus', (e) =>
            if $.isMobile()
                $('.select2-container .select2-focusser').remove()
                $('.select2-search input').prop('focus',false).removeClass('select2-focused')
        @ship_selector.on 'change', (e) =>
            @setShipType @ship_selector.val()
        @ship_selector.data('select2').results.on 'mousemove-filtered', (e) =>
            select2_data = $(e.target).closest('.select2-result').data 'select2-data'
            @builder.showTooltip 'Ship', exportObj.ships[select2_data.id] if select2_data?.id?
        @ship_selector.data('select2').container.on 'mouseover', (e) =>
            @builder.showTooltip 'Ship', exportObj.ships[@pilot.ship] if @pilot

        @pilot_selector.select2
            width: '100%'
            placeholder: exportObj.translate  'ui', 'pilotSelectorPlaceholder'
            query: (query) =>
                data = {results: []}
                data.results = @builder.getAvailablePilotsForShipIncluding(@ship_selector.val(), (if not @builder.isQuickbuild then @pilot else @quickbuildId), query.term, true, @)
                query.callback(data)
            minimumResultsForSearch: if $.isMobile() then -1 else 0
            formatResultCssClass: (obj) =>
                if @builder.collection? and (@builder.collection.checks.collectioncheck == "true")
                    not_in_collection = false
                    name = ""
                    if @builder.isQuickbuild
                        name = exportObj.quickbuildsById[obj.id]?.pilot ? "unknown pilot"
                    else
                        name = obj.name
                    if obj.id == @pilot?.id
                        # Currently selected pilot; mark as not in collection if it's neither
                        # on the shelf nor on the table
                        unless (@builder.collection.checkShelf('pilot', name) or @builder.collection.checkTable('pilot', name))
                            not_in_collection = true
                    else
                        # Not currently selected; check shelf only
                        not_in_collection = not @builder.collection.checkShelf('pilot', name)
                    if not_in_collection then 'select2-result-not-in-collection' else ''
                else
                    ''
        @pilot_selector.on 'select2-focus', (e) =>
            if $.isMobile()
                $('.select2-container .select2-focusser').remove()
                $('.select2-search input').prop('focus',false).removeClass('select2-focused')
        @pilot_selector.on 'change', (e) =>
            @setPilotById @pilot_selector.select2('val')
            @builder.current_squad.dirty = true
            @builder.container.trigger 'xwing-backend:squadDirtinessChanged'
            @builder.backend_status.fadeOut 'slow'
        @pilot_selector.data('select2').results.on 'mousemove-filtered', (e) =>
            select2_data = $(e.target).closest('.select2-result').data 'select2-data'
            if @builder.isQuickbuild
                @builder.showTooltip 'Quickbuild', exportObj.quickbuildsById[select2_data.id], {ship: @data?.name} if select2_data?.id?
            else
                @builder.showTooltip 'Pilot', exportObj.pilotsById[select2_data.id] if select2_data?.id?
        @pilot_selector.data('select2').container.on 'mouseover', (e) =>
            @builder.showTooltip 'Pilot', @pilot, @ if @pilot

        @pilot_selector.data('select2').container.hide()

        if @builder.isQuickbuild
            @wingmate_selector.on 'change', (e) =>
                @setWingmates parseInt @wingmate_selector.val()
                @builder.current_squad.dirty = true
                @builder.container.trigger 'xwing-backend:squadDirtinessChanged'
                @builder.backend_status.fadeOut 'slow'
            @wingmate_selector.on 'mousemove-filtered', (e) =>
                return
                # TODO: show tooltip of wingmate
            #    select2_data = $(e.target).closest('.select2-result').data 'select2-data'
            #    if @builder.isQuickbuild
            #        @builder.showTooltip 'Quickbuild', exportObj.quickbuildsById[select2_data.id], {ship: @data?.name} if select2_data?.id?
            #    else
            #        @builder.showTooltip 'Pilot', exportObj.wingmatesById[select2_data.id] if select2_data?.id?
            #@wingmate_selector.on 'mouseover', (e) =>
            #    @builder.showTooltip 'Pilot', @wingmate, @ if @wingmate
    
        @wingmate_selector.parent().hide()

        @points_container = $ @row.find('.points-display-container')
        @points_container.fadeTo 0, 0

        @addon_container = $ @row.find('div.addon-container')

        @remove_button = $ @row.find('button.remove-pilot')
        @remove_button.click (e) =>
            e.preventDefault()
            @row.slideUp 'fast', () =>
                @builder.removeShip this
                @backend_status?.fadeOut 'slow'
        @remove_button.hide()

        @copy_button = $ @row.find('button.copy-pilot')
        @copy_button.click (e) =>
            for ship in @builder.ships
                if ship.row.hasClass("unsortable")
                    ship.copyFrom(this)
                    break
                
        @copy_button.hide()

        @checkPilotSelectorQueryModal()
        
        @points_destroyed_button_span = $ @row.find('.destroyed-type')
        @points_destroyed_button_span_mobile = $ @row.find('.destroyed-type-mobile')

        @points_destroyed_button = $ @row.find('button.points-destroyed')
        @points_destroyed_button.click (e) =>
            switch @destroystate
                when 0
                    @destroystate++
                    @points_destroyed_button.addClass "btn-warning"
                    @points_destroyed_button.removeClass "btn-light"
                    @points_destroyed_button_span_mobile.text @uitranslation("Half Damaged")
                    @points_destroyed_button_span.html '<i class="fas fa-adjust"></i>'
                when 1
                    @destroystate++
                    @points_destroyed_button.addClass "btn-danger"
                    @points_destroyed_button.removeClass "btn-warning"
                    @points_destroyed_button_span_mobile.text @uitranslation("Fully Destroyed")
                    @points_destroyed_button_span.html '<i class="far fa-circle"></i>'
                when 2
                    @destroystate = 0
                    @points_destroyed_button.addClass "btn-light"
                    @points_destroyed_button.removeClass "btn-danger"
                    @points_destroyed_button_span_mobile.text @uitranslation("Undamaged")
                    @points_destroyed_button_span.html '<i class="fas fa-circle"></i>'


            @builder.container.trigger 'xwing:pointsUpdated'
        @points_destroyed_button.hide()
    
    teardownUI: ->
        @row.text ''
        @row.remove()

    toString: ->
        if @pilot?
            @uitranslation("PilotFlyingShip", (if @pilot.display_name then @pilot.display_name else @pilot.name), (if @data.display_name then @data.display_name else @data.name))
        else
            if @data.display_name then @data.display_name else @data.name

    toHTML: ->
        effective_stats = @effectiveStats()
        action_bar = @builder.formatActions(effective_stats.actions,"<div class=\"action-separator\">&nbsp;&vert;&nbsp;</div>", @pilot.keyword ? [])

        attack_icon = @data.attack_icon ? 'xwing-miniatures-font-frontarc'

        engagementHTML = if (@pilot.engagement?) then $.trim """
            <span class="info-data info-skill">ENG #{@pilot.engagement}</span>
        """ else ''
            
        attackHTML = if (effective_stats.attack?) then $.trim """
            <i class="xwing-miniatures-font header-attack #{attack_icon}"></i>
            <span class="info-data info-attack">#{statAndEffectiveStat((@pilot.ship_override?.attack ? @data.attack), effective_stats, 'attack')}</span>
        """ else ''
        
        if effective_stats.attackbull?
            attackbullHTML = $.trim """<i class="xwing-miniatures-font header-attack xwing-miniatures-font-bullseyearc"></i>
            <span class="info-data info-attack">#{statAndEffectiveStat((@pilot.ship_override?.attackbull ? @data.attackbull), effective_stats, 'attackbull')}</span>""" 
        else
            attackbullHTML = ''
            
        if effective_stats.attackb?
            attackbHTML = $.trim """<i class="xwing-miniatures-font header-attack xwing-miniatures-font-reararc"></i>
            <span class="info-data info-attack">#{statAndEffectiveStat((@pilot.ship_override?.attackb ? @data.attackb), effective_stats, 'attackb')}</span>""" 
        else
            attackbHTML = ''

        if effective_stats.attackf?
            attackfHTML = $.trim """<i class="xwing-miniatures-font header-attack xwing-miniatures-font-fullfrontarc"></i>
            <span class="info-data info-attack">#{statAndEffectiveStat((@pilot.ship_override?.attackf ? @data.attackf), effective_stats, 'attackf')}</span>""" 
        else
            attackfHTML = ''
            
        if effective_stats.attackt?
            attacktHTML = $.trim """<i class="xwing-miniatures-font header-attack xwing-miniatures-font-singleturretarc"></i>
            <span class="info-data info-attack">#{statAndEffectiveStat((@pilot.ship_override?.attackt ? @data.attackt), effective_stats, 'attackt')}</span>""" 
        else
            attacktHTML = ''
            
        if effective_stats.attackl?
            attacklHTML = $.trim """<i class="xwing-miniatures-font header-attack xwing-miniatures-font-leftarc"></i>
            <span class="info-data info-attack">#{statAndEffectiveStat((@pilot.ship_override?.attackl ? @data.attackl), effective_stats, 'attackl')}</span>""" 
        else
            attacklHTML = ''
            
        if effective_stats.attackr?
            attackrHTML = $.trim """<i class="xwing-miniatures-font header-attack xwing-miniatures-font-rightarc"></i>
            <span class="info-data info-attack">#{statAndEffectiveStat((@pilot.ship_override?.attackr ? @data.attackr), effective_stats, 'attackr')}</span>""" 
        else
            attackrHTML = ''
            
        if effective_stats.attackdt?
            attackdtHTML = $.trim """<i class="xwing-miniatures-font header-attack xwing-miniatures-font-doubleturretarc"></i>
            <span class="info-data info-attack">#{statAndEffectiveStat((@pilot.ship_override?.attackdt ? @data.attackdt), effective_stats, 'attackdt')}</span>""" 
        else
            attackdtHTML = ''

        
        recurringicon = ''
        if @data.energyrecurr?
            count = 0
            while count < @data.energyrecurr
                recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
                ++count
        
        energyHTML = if (@pilot.ship_override?.energy? or @data.energy?) then $.trim """
            <i class="xwing-miniatures-font header-energy xwing-miniatures-font-energy"></i>
            <span class="info-data info-energy">#{statAndEffectiveStat((@pilot.ship_override?.energy ? @data.energy), effective_stats, 'energy')}#{recurringicon}</span>
        """ else ''
        

        if effective_stats.force?
            recurringicon = ''
            if effective_stats.forcerecurring?
                count = 0
                while count < effective_stats.forcerecurring 
                    recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
                    ++count
            else
                recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
        forceHTML = if (effective_stats.force? and effective_stats.force > 0) then $.trim """
            <i class="xwing-miniatures-font header-force xwing-miniatures-font-forcecharge"></i>
            <span class="info-data info-force">#{statAndEffectiveStat((@pilot.ship_override?.force ? @pilot.force ? 0), effective_stats, 'force')}#{recurringicon}</span>
        """ else ''

        if @pilot.charge?
            recurringicon = ''
            if @pilot.recurring?
                if @pilot.recurring > 0
                    count = 0
                    while count < @pilot.recurring
                        recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
                        ++count
                else
                    count = @pilot.recurring
                    while count < 0
                        recurringicon += '<sub><i class="fas fa-caret-down"></i></sub>'
                        ++count
            chargeHTML = $.trim """<i class="xwing-miniatures-font header-charge xwing-miniatures-font-charge"></i><span class="info-data info-charge">#{statAndEffectiveStat((@pilot.ship_override?.charge ? @pilot.charge), effective_stats, 'charge')}#{recurringicon}</span>"""
        else 
            chargeHTML = ''

        shieldRECUR = ''
        if @data.shieldrecurr?
            count = 0
            while count < @data.shieldrecurr
                shieldRECUR += """<sup><i class="fas fa-caret-up"></i></sup>"""
                ++count
            
        shieldIconHTML = ''
        if effective_stats.shields
            for _ in [effective_stats.shields..2] by -1
                shieldIconHTML += """<i class="xwing-miniatures-font header-shield xwing-miniatures-font-shield expanded-hull-or-shield"></i>"""
            shieldIconHTML += """<i class="xwing-miniatures-font header-shield xwing-miniatures-font-shield"></i>"""

        hullIconHTML = ''
        if effective_stats.hull
            for _ in [effective_stats.hull..2] by -1
                hullIconHTML += """<i class="xwing-miniatures-font header-hull xwing-miniatures-font-hull expanded-hull-or-shield"></i>"""
            hullIconHTML += """<i class="xwing-miniatures-font header-hull xwing-miniatures-font-hull"></i>"""

        shieldHTML = if (effective_stats.shields? and effective_stats.shields > 0) then $.trim """
            <span class="info-data info-shields">#{statAndEffectiveStat((@pilot.ship_override?.shields ? @data.shields), effective_stats, 'shields')}#{shieldRECUR}</span>
        """ else ''

        html = $.trim """
            <div class="fancy-pilot-header">
                <div class="pilot-header-text">#{if @pilot.display_name then @pilot.display_name else @pilot.name} <i class="xwing-miniatures-ship xwing-miniatures-ship-#{@data.name.canonicalize()}"></i><span class="fancy-ship-type"> #{if @data.display_name then @data.display_name else @data.name}</span></div>
                <div class="mask">
                    <div class="outer-circle">
                        <div class="inner-circle pilot-points">#{if @quickbuildId != -1 then (if @primary then @getPoints() else '*') else (if (@builder.isXwa and @pilot.pointsxwa?) then @pilot.pointsxwa else @pilot.points)}</div>
                    </div>
                </div>
            </div>
            <div class="fancy-pilot-stats">
                <div class="pilot-stats-content">
                    <span class="info-data info-skill">INI #{statAndEffectiveStat(@pilot.skill, effective_stats, 'skill')}</span>
                    #{engagementHTML}
                    #{attackbullHTML}
                    #{attackHTML}
                    #{attackbHTML}
                    #{attackfHTML}
                    #{attacktHTML}
                    #{attacklHTML}
                    #{attackrHTML}
                    #{attackdtHTML}
                    <i class="xwing-miniatures-font header-agility xwing-miniatures-font-agility"></i>
                    <span class="info-data info-agility">#{statAndEffectiveStat((@pilot.ship_override?.agility ? @data.agility), effective_stats, 'agility')}</span>                    
                    #{hullIconHTML}
                    <span class="info-data info-hull">#{statAndEffectiveStat((@pilot.ship_override?.hull ? @data.hull), effective_stats, 'hull')}</span>
                    #{shieldIconHTML}
                    #{shieldHTML}
                    #{energyHTML}
                    #{forceHTML}
                    #{chargeHTML}
                    <br />
                    <div class="action-bar">
                        #{action_bar}
                    </div>
                </div>
            </div>
        """
        
        
        if @pilot.text
            html += $.trim """
                <div class="fancy-pilot-text">#{@pilot.text}</div>
            """
        if effective_stats?.chassis? and (effective_stats.chassis != "")
            chassis_title = effective_stats.chassis
        else if @data.chassis? 
            chassis_title = @data.chassis
        else
            chassis_title = ""
        if chassis_title != ""
            html += $.trim """
                <div class="fancy-pilot-chassis"><strong>#{exportObj.chassis[chassis_title]?.display_name ? chassis_title}:</strong> #{exportObj.chassis[chassis_title].text}</div>
            """

        slotted_upgrades = (upgrade for upgrade in @upgrades when upgrade.data?)

        if slotted_upgrades.length > 0
            html += $.trim """
                <div class="fancy-upgrade-container">
            """

            for upgrade in slotted_upgrades
                points = upgrade.getPoints()
                html += upgrade.toHTML points

            html += $.trim """
                </div>
            """
        
        HalfPoints = Math.floor @getPoints() / 2
        

        Threshold = Math.floor (effective_stats['hull'] + effective_stats['shields']) / 2
        
        html += $.trim """
            <div class="ship-points-total">
                <strong>#{@uitranslation("Ship Cost")}: #{@getPoints()}, #{@uitranslation("Loadout")}: (#{@upgrade_points_total}#{if (@builder.isXwa and @pilot.loadoutxwa?) then "/#{@pilot.loadoutxwa}" else (if @pilot.loadout? then "/#{@pilot.loadout}" else "")}), #{@uitranslation("Half Points")}: #{HalfPoints}, #{@uitranslation("Damage Threshold")}: #{Threshold}</strong> 
            </div>
        """

        """<div class="fancy-ship">#{html}</div>"""

    toTableRow: ->
        table_html = $.trim """
            <tr class="simple-pilot">
                <td class="name">#{if @pilot.display_name then @pilot.display_name else @pilot.name} &mdash; #{if @data.display_name then @data.display_name else @data.name}</td>
                <td class="points">#{if @quickbuildId != -1 then (if @primary then exportObj.quickbuildsById[@quickbuildId].threat else 0) else (if (@builder.isXwa and @pilot.pointsxwa?) then @pilot.pointsxwa else @pilot.points)}</td>
            </tr>
        """

        slotted_upgrades = (upgrade for upgrade in @upgrades when upgrade.data?)
        if slotted_upgrades.length > 0
            for upgrade in slotted_upgrades
                points = upgrade.getPoints()
                table_html += upgrade.toTableRow points

        table_html += """<tr class="simple-ship-total"><td colspan="2">#{@uitranslation("Ship Cost")}: #{@getPoints()}</td></tr>"""
        
        halfPoints = Math.floor @getPoints() / 2        
        threshold = Math.floor (@effectiveStats()['hull'] + @effectiveStats()['shields']) / 2

        table_html += """<tr class="simple-ship-half-points"><td colspan="2">#{@uitranslation("Loadout")}: (#{@upgrade_points_total}#{if (@builder.isXwa and @pilot.loadoutxwa?) then "/#{@pilot.loadoutxwa}" else (if @pilot.loadout? then "/#{@pilot.loadout}" else "")}) #{@uitranslation("Half Points")}: #{halfPoints} #{@uitranslation("Damage Threshold")}: #{threshold}</td></tr>"""

        table_html += '<tr><td>&nbsp;</td><td></td></tr>'
        table_html

    toSimpleCopy: ->
        simplecopy = """#{@pilot.display_name} – #{@data.display_name} (#{if @quickbuildId != -1 then (if @primary then exportObj.quickbuildsById[@quickbuildId].threat else 0) else (if (@builder.isXwa and @pilot.pointsxwa?) then @pilot.pointsxwa else @pilot.points)})    \n"""
        slotted_upgrades = (upgrade for upgrade in @upgrades when upgrade.data?)
        if slotted_upgrades.length > 0
            simplecopy +="    "
            simplecopy_upgrades= []
            for upgrade in slotted_upgrades
                points = upgrade.getPoints()
                upgrade_simplecopy = upgrade.toSimpleCopy points
                simplecopy_upgrades.push upgrade_simplecopy if upgrade_simplecopy?
            simplecopy += simplecopy_upgrades.join "    "
            simplecopy += """    \n"""

        halfPoints = Math.floor @getPoints() / 2        
        threshold = Math.floor (@effectiveStats()['hull'] + @effectiveStats()['shields']) / 2

        simplecopy += """#{@uitranslation("Ship Cost")}: #{@getPoints()}  #{@uitranslation("Loadout")}: (#{@upgrade_points_total}#{if (@builder.isXwa and @pilot.loadoutxwa?) then "/#{@pilot.loadoutxwa}" else (if @pilot.loadout? then "/#{@pilot.loadout}" else "")})  #{@uitranslation("Half Points")}: #{halfPoints}  #{@uitranslation("Damage Threshold")}: #{threshold}    \n    \n"""

        simplecopy
        
        
    toRedditText: ->
        reddit = """**#{@pilot.name} (#{if @quickbuildId != -1 then (if @primary then exportObj.quickbuildsById[@quickbuildId].threat else 0) else (if (@builder.isXwa and @pilot.pointsxwa?) then @pilot.pointsxwa else @pilot.points)})**    \n"""
        slotted_upgrades = (upgrade for upgrade in @upgrades when upgrade.data?)
        if slotted_upgrades.length > 0
            halfPoints = Math.floor @getPoints() / 2
            threshold = Math.floor (@effectiveStats()['hull'] + @effectiveStats()['shields']) / 2
            reddit +="    "
            reddit_upgrades= []
            for upgrade in slotted_upgrades
                points = upgrade.getPoints()
                upgrade_reddit = upgrade.toRedditText points
                reddit_upgrades.push upgrade_reddit if upgrade_reddit?
            reddit += reddit_upgrades.join "    "
            reddit += """&nbsp;*#{@uitranslation("Ship Cost")}: #{@getPoints()}  #{@uitranslation("Loadout")}: (#{@upgrade_points_total}#{if (@builder.isXwa and @pilot.loadoutxwa?) then "/#{@pilot.loadoutxwa}" else (if @pilot.loadout? then "/#{@pilot.loadout}" else "")})  #{@uitranslation("Half Points")}: #{halfPoints}  #{@uitranslation("Damage Threshold")}: #{threshold}*    \n"""
            
        reddit

    toTTSText: ->
        tts = """#{exportObj.toTTS(@pilot.name)}"""
        slotted_upgrades = (upgrade for upgrade in @upgrades when upgrade.data?)
        if slotted_upgrades.length > 0 and not @pilot.upgrades?
            for upgrade in slotted_upgrades
                upgrade_tts = upgrade.toTTSText()
                tts += (" + " + upgrade_tts) if upgrade_tts?
        tts += " / "

    toSerialized: ->
        # PILOT_ID:UPGRADEID1,UPGRADEID2:CONFERREDADDONTYPE1.CONFERREDADDONID1,CONFERREDADDONTYPE2.CONFERREDADDONID2
        if @builder.isQuickbuild
            if (!@wingmates? || @wingmates.length == 0) then """#{@quickbuildId}X""" else """#{@quickbuildId}X#{@wingmates.length}"""
        else
            upgrades = """#{upgrade?.data?.id ? "" for upgrade, i in @upgrades}""".replace(/,/g, "W")
            [
                @pilot.id,
                upgrades,
            ].join 'X'


    fromSerialized: (version, serialized) ->
    # adds a ship from the given serialized data to the squad. 
    # returns true, if all upgrades have been added successfully, false otherwise
    # returning false does not necessary mean nothing has been added, but some stuff might have been dropped (e.g. 0-0-0 if vader is not yet in the squad)
        everythingadded = true
        switch version
            when 1, 2, 3, 4, 5, 6, 7, 8
                # v 1-3 are 1st Ed
                # v 4-8 are 2nd Ed 
                # v 9+ are 2.5 Ed 
                console.log "Incorrect Version!"
                @old_version_container.toggleClass 'd-none', false

            when 9
                pilot_splitter = 'X'
                upgrade_splitter = 'W'
                [ pilot_id, upgrade_ids, conferredaddon_pairs ] = serialized.split pilot_splitter
                upgrade_ids = upgrade_ids.split upgrade_splitter
                # set the pilot
                await @setPilotById parseInt(pilot_id), true
                # make sure the pilot is valid 
                return false unless @validate
                
                if !@builder.isQuickbuild
                    # iterate over upgrades to be added, and remove all that have been successfully added
                    for _ in [1 ... 3] # try adding each upgrade a few times, as the required slots might be added in by titles etc and are not yet available on the first try
                        `upgradeloop: //` 
                        for i in [upgrade_ids.length - 1 ... -1]
                            upgrade_id = upgrade_ids[i]
                            upgrade = exportObj.upgradesById[upgrade_id]
                            if not upgrade? 
                                upgrade_ids.splice(i,1) # Remove unknown or empty ID
                                if upgrade_id != ""
                                    console.log("Unknown upgrade id " + upgrade_id + " could not be added. Please report that error")
                                    everythingadded = false
                                continue
                            for upgrade_selection in @upgrades
                                if upgrade_selection?.data?.name == upgrade.name
                                    # for some reason the correct upgrade already was equipped (e.g. an earlier ship alread had a standardized that was added on creation here)
                                    upgrade_ids.splice(i,1) # was already added successfully, remove from list
                                    `continue upgradeloop`

                            for upgrade_selection in @upgrades
                                if exportObj.slotsMatching(upgrade.slot, upgrade_selection.slot) and not upgrade_selection.isOccupied()
                                    await upgrade_selection.setById upgrade_id
                                    if upgrade_selection.lastSetValid
                                        upgrade_ids.splice(i,1) # added successfully, remove from list
                                    break
                else 
                    # we are in quickbuild. Number of wingmates might be provided as upgrade ID of a quickbuild
                    if upgrade_ids.length > 0 && @wingmates.length > 0 # check if we are actually a wingleader
                        @setWingmates(upgrade_ids[0])
                everythingadded &= upgrade_ids.length == 0
                          
        @updateSelections()
        everythingadded

    effectiveStats: ->
        stats =
            attack: @pilot.ship_override?.attack ? @data.attack
            attackf: @pilot.ship_override?.attackf ? @data.attackf
            attackbull: @pilot.ship_override?.attackbull ? @data.attackbull
            attackb: @pilot.ship_override?.attackb ? @data.attackb
            attackt: @pilot.ship_override?.attackt ? @data.attackt
            attackl: @pilot.ship_override?.attackl ? @data.attackl
            attackr: @pilot.ship_override?.attackr ? @data.attackr
            attackdt: @pilot.ship_override?.attackdt ? @data.attackdt
            energy: @pilot.ship_override?.energy ? @data.energy
            agility: @pilot.ship_override?.agility ? @data.agility
            hull: @pilot.ship_override?.hull ? @data.hull
            shields: @pilot.ship_override?.shields ? @data.shields
            force: (@pilot.ship_override?.force ? @pilot.force) ? 0
            forcerecurring: @pilot.forcerecurring ? 1
            charge: @pilot.ship_override?.charge ? @pilot.charge
            actions: (@pilot.ship_override?.actions ? @data.actions).slice 0
            chassis: @pilot.chassis ? @data.chassis ? ""
            points: @pilot.points ? 0
            loadout: @pilot.loadout ? 0
            skill: @pilot.skill ? 0

        # override when in XWA mode
        if @builder.isXwa
            if @pilot.pointsxwa? then stats.points = @pilot.pointsxwa
            if @pilot.loadoutxwa? then stats.loadout = @pilot.loadoutxwa

        # need a deep copy of maneuvers array
        maneuvers_override = @pilot.ship_override?.maneuvers ? @data.maneuvers
        stats.maneuvers = []
        for s in [0 ... (maneuvers_override ? []).length]
            stats.maneuvers[s] = maneuvers_override[s].slice 0

        # Droid conversion of Focus to Calculate
        if @pilot.keyword? and ("Droid" in @pilot.keyword) and stats.actions?
            new_stats = []
            for statentry in stats.actions
                new_stats.push statentry.replace("Focus","Calculate")
            stats.actions = new_stats

        for upgrade in @upgrades
            if upgrade?.data?.chassis? then stats.chassis = upgrade.data.chassis
            upgrade.data.modifier_func(stats) if upgrade?.data?.modifier_func?
        @pilot.modifier_func(stats) if @pilot?.modifier_func?

        if exportObj.chassis[stats.chassis]? and exportObj.chassis[stats.chassis].modifier_func?
            exportObj.chassis[stats.chassis].modifier_func(stats)

        stats

    validate: ->
        # while we load a squad we defer the validation to after everything is loaded, as there might be a lot of mutual dependencies.
        if @builder.isCurrentlyLoadingSquad
            return true
        # Remove addons that violate their validation functions (if any) one by one until everything checks out
        # Returns true, if nothing has been changed, and false otherwise
        # check if we are an empty selection, which is always valid
        if not @pilot?
            return true 
        unchanged = true
        max_checks = 8 # that's a lot of addons
        
        if @builder.isEpic #Command Epic adding
            if @pilot.slots? and not ("Command" in @pilot.slots)
                addCommand = true
                for upgrade in @upgrades
                    if ("Command" == upgrade.slot) and (this == upgrade.ship)
                        addCommand = false
                if addCommand == true
                    @upgrades.push new exportObj.Upgrade
                        ship: this
                        container: @addon_container
                        slot: "Command"
        else if !@builder.isQuickbuild #cleanup Command upgrades
            for i in [@upgrades.length - 1 ... -1]
                upgrade = @upgrades[i]
                if upgrade.slot == "Command"
                    upgrade.destroy $.noop
                    @upgrades.splice i,1

        for i in [0...max_checks]
            valid = true
            pilot_func = @pilot?.validation_func ? @pilot?.restriction_func ? undefined
            pilot_upgrades_check = @pilot.upgrades?
            if (pilot_func? and not pilot_func(this, @pilot)) or not (@builder.isItemAvailable(@pilot, true))
                # we go ahead and happily remove ourself. Of course, when calling a method like validate on an object, you have to expect that it will dissappear, right?
                @builder.removeShip this 
                return false # no need to check anything further, as we do not exist anymore 
            # everything is limited in X-Wing 2.0, so we need to check if any upgrade is equipped more than once
            equipped_upgrades = []
            @upgrade_points_total = 0
            for upgrade in @upgrades
                meets_restrictions = true
                if not pilot_upgrades_check
                    func = upgrade?.data?.validation_func ? undefined
                    if func?
                        meets_restrictions = meets_restrictions and upgrade?.data?.validation_func(this, upgrade)
                    # moved occupied slots off of validation func
                    if @builder.isXwa and upgrade?.data?.also_occupies_upgrades_xwa?
                        for upgradeslot in upgrade.data.also_occupies_upgrades_xwa
                            meets_restrictions = meets_restrictions and upgrade.occupiesAnUpgradeSlot(upgradeslot)
                    else
                        if upgrade?.data?.also_occupies_upgrades?
                            for upgradeslot in upgrade.data.also_occupies_upgrades
                                meets_restrictions = meets_restrictions and upgrade.occupiesAnUpgradeSlot(upgradeslot)

                    restrictions = if upgrade?.data?.restrictionsxwa? and @builder.isXwa then upgrade?.data?.restrictionsxwa else upgrade?.data?.restrictions ? undefined
                    # always perform this check, even if no special restrictions for this upgrade exists, to check for allowed points
                    meets_restrictions = meets_restrictions and @restriction_check(restrictions, upgrade, upgrade.getPoints(), @upgrade_points_total)

                # ignore those checks if this is a pilot with upgrades or quickbuild
                if (not meets_restrictions or (upgrade?.data? and (upgrade.data in equipped_upgrades or (upgrade.data.faction? and not @builder.isOurFaction(upgrade.data.faction,@pilot.faction)) or not @builder.isItemAvailable(upgrade.data)))) and not pilot_upgrades_check and not @builder.isQuickbuild
                    console.log "Invalid upgrade: #{upgrade?.data?.name} on pilot #{@pilot?.name}"
                    await upgrade.setById null
                    valid = false
                    unchanged = false
                    break
                if upgrade?.data? and upgrade.data
                    equipped_upgrades.push(upgrade?.data)
                @upgrade_points_total += upgrade.getPoints()
            break if valid
        @updateSelections()
        unchanged

    checkUnreleasedContent: ->
        if @pilot? and not exportObj.isReleased @pilot
            #console.log "#{@pilot.name} is unreleased"
            return true

        for upgrade in @upgrades
            if upgrade?.data? and (not exportObj.isReleased upgrade.data) and (not upgrade.data.standard?)
                #console.log "#{upgrade.data.id} is unreleased"
                return true

        false

    hasAnotherUnoccupiedSlotLike: (upgrade_obj, upgradeslot) ->
        for upgrade in @upgrades
            continue if upgrade == upgrade_obj or not exportObj.slotsMatching(upgrade.slot, upgradeslot) or upgrade.slot == "HardpointShip" or upgrade.slot == "VersatileShip"
            return true unless upgrade.isOccupied()
        false

    hasFilledSlotLike: (upgrade_obj, upgradeslot) ->
        for upgrade in @upgrades
            continue if upgrade == upgrade_obj or not exportObj.slotsMatching(upgrade.slot, upgradeslot)
            if upgrade.isOccupied()
                return true
        false


    restriction_check: (restrictions, upgrade_obj, points = 0, current_upgrade_points = 0, upgrade_data = undefined) ->
        effective_stats = @effectiveStats()
        if @pilot.loadout?
            loadout = effective_stats.loadout
            if (points + current_upgrade_points > loadout)
                return false
        if restrictions?
            for r in restrictions
                switch r[0]
                    when "FactionOrUnique"
                        if @pilot.faction != r[2] and not @checkListForUnique(r[1].toLowerCase().replace(/[^0-9a-z]/gi, '').replace(/\s+/g, '-')) then return false
                    when "Base"
                        check = false
                        for b in r
                            if b == "Base" then continue
                            if b.startsWith("Non-") then base = b.substring(4) else base = b # check if its an non- case then remove the non-
                            switch base
                                when "Small"
                                    if not @data.base? then check = true
                                when "Standard"
                                    if not (@data.base? and @data.base == "Huge") then check = true
                                else
                                    if @data.base? and @data.base == base then check = true
                            if b != base then check = !check # invert results for non- result
                            if check == true then break
                        if check == false then return false
                    when "Action"
                        if r[1].startsWith("W-")
                            w = r[1].substring(2)
                            if w not in effective_stats.actions then return false
                        else
                            check = false
                            for action in effective_stats.actions
                                if action.includes(r[1]) and not action.includes(">")
                                    check = true
                            if check is false then return false
                    when "Keyword"
                        if not (@checkKeyword(r[1])) then return false
                    when "Equipped"
                        if not ((@doesSlotExist(r[1]) and @hasFilledSlotLike(upgrade_obj, r[1]))) then return false
                    when "Slot"
                        if (not @hasAnotherUnoccupiedSlotLike(upgrade_obj, r[1]) and not upgrade_obj?.occupiesAnUpgradeSlot?(r[1])) or  upgrade_obj.slot == "HardpointShip" or  upgrade_obj.slot == "VersatileShip"  then return false
                    when "AttackArc"
                        if not @data.attackb? then return false
                    when "ShieldsGreaterThan"
                        if not (@data.shields > r[1]) then return false
                    when "EnergyGreatterThan"
                        if not (effective_stats.energy > r[1]) then return false
                    when "InitiativeGreaterThan"
                        if not (@pilot.skill > r[1]) then return false
                    when "InitiativeLessThan"
                        if not (@pilot.skill < r[1]) then return false
                    when "HasForce"
                        if @pilot.force? != r[1] then false
                    when "AgilityEquals"
                        if not (effective_stats.agility == r[1]) then return false
                    when "isUnique"
                        if r[1] != (@pilot.unique? or @pilot.max_per_squad?) then return false
                    when "Format"
                        switch r[1]
                            when "Epic"
                                if not (@data.name in exportObj.epicExclusionsList) then return false
                            when "Standard"
                                if @data.name in exportObj.epicExclusionsList then return false
        return true

    standardized_check: (upgrade_data) ->
        # condition checks
        checkstandard = false
        if @builder.isXwa
            if upgrade_data.standardizedxwa?
                checkstandard = upgrade_data.standardizedxwa
        else 
            if upgrade_data.standardized?
                checkstandard = true

        if checkstandard
            for ship in @builder.ships
                if ship?.data? and ship.data.name == @data.name
                    if @builder.isXwa
                        if upgrade_data.restrictionsxwa? then restrictions = upgrade_data.restrictionsxwa else (if upgrade_data.restrictions? then restrictions = upgrade_data.restrictions)
                    if restrictions? and ship.restriction_check(restrictions, upgrade_data) and not (ship.pilot?.upgrades?)
                        if ship.pilot.loadout? and (upgrade_data.points + ship.upgrade_points_total > ship.pilot.loadout)
                            return false
                        slotfree = false
                        for upgrade in ship.upgrades
                            if upgrade_data.slot == upgrade.slot and not upgrade.data?
                                slotfree = true
                        if slotfree == false
                            return false
        return true

    doesSlotExist: (slot) ->
        for upgrade in @upgrades
            if exportObj.slotsMatching(upgrade.slot, slot)
                return true
        false
    
    isSlotOccupied: (slot_name) ->
        for upgrade in @upgrades
            if exportObj.slotsMatching(upgrade.slot, slot_name)
                return true unless upgrade.isOccupied()
        false

    checkKeyword: (keyword) ->
        if @data.name?.includes(keyword)
            return true
        if @pilot.chassis?
            if @pilot.chassis == keyword
                return true
        else 
            if @data.chassis? and @data.chassis == keyword
                return true
        for words in @data.keyword ? []
            if words == keyword
                return true
        for words in @pilot.keyword ? []
            if words == keyword
                return true
        for upgrade in @upgrades
            if upgrade.chassis? and upgrade.chassis == keyword
                return true
            for word in upgrade?.data?.keyword ? []
                if word == keyword
                    return true
        false

    checkListForUnique: (name) ->
        for t, things of @builder.uniques_in_use
            if t != 'Slot'
                return true if name in (thing.canonical_name.getXWSBaseName() for thing in things)
        false

    toXWS: ->
        xws =
            id: (@pilot.xws ? @pilot.canonical_name)
            name: (@pilot.xws ? @pilot.canonical_name) # name is no longer part of xws 2.0.0, and was replaced by id. However, we will add it here for some kind of backward compatibility. May be removed, as soon as everybody is using id. 
            points: @getPoints()
            #ship: @data.canonical_name
            ship: @data.name.canonicalize()

        if @data.multisection
            xws.multisection = @data.multisection.slice 0

        upgrade_obj = {}

        if not @pilot.upgrades
            for upgrade in @upgrades
                if upgrade?.data?
                    upgrade.toXWS upgrade_obj

        if Object.keys(upgrade_obj).length > 0
            xws.upgrades = upgrade_obj

        xws

    getConditions: ->
        if Set?
            conditions = new Set()
            if @pilot?.applies_condition?
                if @pilot.applies_condition instanceof Array
                    for condition in @pilot.applies_condition
                        conditions.add(exportObj.conditionsByCanonicalName[condition])
                else
                    conditions.add(exportObj.conditionsByCanonicalName[@pilot.applies_condition])
            for upgrade in @upgrades
                if upgrade?.data?.applies_condition?
                    if upgrade.data.applies_condition instanceof Array
                        for condition in upgrade.data.applies_condition
                            conditions.add(exportObj.conditionsByCanonicalName[condition])
                    else
                        conditions.add(exportObj.conditionsByCanonicalName[upgrade.data.applies_condition])
            conditions
        else
            console.warn 'Set not supported in this JS implementation, not implementing conditions'
            []

class GenericAddon
    constructor: (args) ->
        # args
        @ship = args.ship
        @container = $ args.container

        # internal state
        @data = null
        @unadjusted_data = null
        @conferredAddons = []
        @serialization_code = 'X'
        @occupied_by = null
        @occupying = []
        @destroyed = false

        # Overridden by children
        @type = null
        @dataByName = null
        @dataById = null

        @adjustment_func = args.adjustment_func if args.adjustment_func?
        @filter_func = args.filter_func if args.filter_func?
        @placeholderMod_func = if args.placeholderMod_func? then args.placeholderMod_func else (x) => x

    destroy: (cb, args...) ->
        return cb(args) if @destroyed
        if @data?.unique?
            await new Promise((resolve,reject) =>@ship.builder.container.trigger 'xwing:releaseUnique', [ @data, @type, resolve ])
        if @isStandardized()
            isLastShip = true
            for ship in @ship.builder.ships
                if ship.data? and (@ship.data.name == ship.data.name) and (@ship != ship)
                    isLastShip = false
            if isLastShip == true
                @ship.removeStandardizedList(@data)
        @destroyed = true
        @rescindAddons()
        @deoccupyOtherUpgrades()
        @selector.select2 'destroy'
        @selectorwrap.remove()
        cb args

    isStandardized: ->
        if @ship.builder.isXwa
            if @data?.standardizedxwa?
                return @data.standardizedxwa
        if @data?.standardized?
            return true
        return false

    setupSelector: (args) ->
        @selectorwrap = $ document.createElement 'div'
        @selectorwrap.addClass 'form-group d-flex upgrade-box'
        
        @selector = $ document.createElement 'INPUT'
        @selector.attr 'type', 'hidden'

        @selectorwrap.append @selector
        @selectorwrap.append $.trim '''
            <div class="input-group-addon">
                <button class="btn btn-secondary d-block d-md-none upgrade-query-modal"><i class="fas fa-question"></i></button>
            </div>
        '''
        @upgrade_query_modal = $ @selectorwrap.find('button.upgrade-query-modal')
        
        @container.append @selectorwrap
        args.minimumResultsForSearch = -1 if $.isMobile()
        args.formatResultCssClass = (obj) =>
            if @ship.builder.collection?
                not_in_collection = false
                if obj.id == @data?.id
                    # Currently selected card; mark as not in collection if it's neither
                    # on the shelf nor on the table
                    unless (@ship.builder.collection.checkShelf(@type.toLowerCase(), obj.name) or @ship.builder.collection.checkTable(@type.toLowerCase(), obj.name)) 
                        not_in_collection = true
                else
                    # Not currently selected; check shelf only
                    not_in_collection = not @ship.builder.collection.checkShelf(@type.toLowerCase(), obj.name)
                if not_in_collection then 'select2-result-not-in-collection' else ''
            else
                ''
        
        args.formatSelection = (obj, container) =>
            icon = switch @type
                when 'Upgrade'
                    @slot.toLowerCase().replace(/[^0-9a-z]/gi, '')
                else
                    @type.toLowerCase().replace(/[^0-9a-z]/gi, '')
                    
            icon = icon.replace("configuration", "config")
                        .replace("force", "forcepower")
                
            # Append directly so we don't have to disable markup escaping
            $(container).append """<i class="xwing-miniatures-font xwing-miniatures-font-#{icon}"></i> #{obj.text}"""
            # If you return a string, Select2 will render it
            undefined

        @selector.select2 args
        
        @upgrade_query_modal.click (e) =>
            if @data
                console.log "#{@data.name}"
                @ship.builder.showTooltip 'Addon', @data, ({addon_type: @type} if @data?) , @ship.builder.mobile_tooltip_modal, true
                @ship.builder.mobile_tooltip_modal.modal 'show'

        @selector.on 'select2-focus', (e) =>
            if $.isMobile()
                $('.select2-container .select2-focusser').remove()
                $('.select2-search input').prop('focus',false).removeClass('select2-focused')
        @selector.on 'change', (e) =>
            @setById @selector.select2('val')
            @ship.builder.current_squad.dirty = true
            @ship.builder.container.trigger 'xwing-backend:squadDirtinessChanged'
            @ship.builder.backend_status.fadeOut 'slow'
        @selector.data('select2').results.on 'mousemove-filtered', (e) =>
            select2_data = $(e.target).closest('.select2-result').data 'select2-data'
            @ship.builder.showTooltip 'Addon', @dataById[select2_data.id], {addon_type: @type} if select2_data?.id?
        @selector.data('select2').container.on 'mouseover', (e) =>
            @ship.builder.showTooltip 'Addon', @data, {addon_type: @type} if @data?

    setById: (id) ->
        @setData @dataById[parseInt id]

    setByName: (name) ->
        @setData @dataByName[$.trim name]

    setData: (new_data) ->
        if new_data?.id != @data?.id
            if @data?.unique? or @data?.solitary?
                await new Promise((resolve,reject) => @ship.builder.container.trigger 'xwing:releaseUnique', [ @unadjusted_data, @type, resolve ])
            if @isStandardized() and not @ship.hasFixedUpgrades
                @ship.removeStandardizedList(@data)
            await @rescindAddons()
            @deoccupyOtherUpgrades()
            if new_data?.unique? or new_data?.solitary?
                try
                    await new Promise((resolve,reject) => @ship.builder.container.trigger 'xwing:claimUnique', [ new_data, @type, resolve ])
                catch alreadyClaimed
                    @ship.builder.container.trigger 'xwing:pointsUpdated'
                    @lastSetValid = false
                    return
            # Need to make a copy of the data, but that means I can't just check equality
            @data = @unadjusted_data = new_data

            if @data?
                if @data.superseded_by_id
                    return @setById @data.superseded_by_id
                if @adjustment_func?
                    @data = @adjustment_func(@data)
                if not @ship.pilot?.upgrades?
                    @unequipOtherUpgrades()
                    @occupyOtherUpgrades()
                    @conferAddons()
                if @isStandardized() and not @ship.hasFixedUpgrades
                    @ship.addToStandardizedList(@data)
            else
                @deoccupyOtherUpgrades()

            # this will remove not allowed upgrades (is also done on pointsUpdated). We do it explicitly so we can tell if the setData was successfull
            await @lastSetValid = @ship.validate()
            @ship.builder.container.trigger 'xwing:pointsUpdated'

    conferAddons: ->
        if @data.confersAddons? and !@ship.builder.isQuickbuild and @data.confersAddons.length > 0
            for addon in @data.confersAddons
                cls = addon.type
                args =
                    ship: @ship
                    container: @container
                args.slot = addon.slot if addon.slot?
                args.adjustment_func = addon.adjustment_func if addon.adjustment_func?
                args.filter_func = addon.filter_func if addon.filter_func?
                args.auto_equip = addon.auto_equip if addon.auto_equip?
                args.placeholderMod_func = addon.placeholderMod_func if addon.placeholderMod_func?
                addon = new cls args
                if addon instanceof exportObj.Upgrade
                    @ship.upgrades.push addon
                else
                    throw new Error("Unexpected addon type for addon #{addon}")
                @conferredAddons.push addon
        if @data.chassis? and !@ship.builder.isQuickbuild and exportObj.chassis[@data.chassis].conferredAddons?
            for addon in exportObj.chassis[@data.chassis].conferredAddons
                cls = addon.type
                args =
                    ship: @ship
                    container: @container
                args.slot = addon.slot if addon.slot?
                args.adjustment_func = addon.adjustment_func if addon.adjustment_func?
                args.filter_func = addon.filter_func if addon.filter_func?
                args.auto_equip = addon.auto_equip if addon.auto_equip?
                args.placeholderMod_func = addon.placeholderMod_func if addon.placeholderMod_func?
                addon = new cls args
                if addon instanceof exportObj.Upgrade
                    @ship.upgrades.push addon
                else
                    throw new Error("Unexpected addon type for addon #{addon}")
                @conferredAddons.push addon
                
    rescindAddons: ->
        destroyed_addons = []
        for addon in @conferredAddons
            destroyed_addons.push(new Promise ((resolve,reject) => addon.destroy resolve))
        await Promise.all destroyed_addons
        for addon in @conferredAddons
            if addon instanceof exportObj.Upgrade
                @ship.upgrades.removeItem addon
            else
                throw new Error("Unexpected addon type for addon #{addon}")
        @conferredAddons = []

    getPoints: (data = @data, ship = @ship) ->
        # Moar special case jankiness
        if @ship?.builder.isXwa and data?.pointsxwa?
            points = data.pointsxwa
        else 
            points = data?.points ? 0

        if Array.isArray(points)
            switch data.variablepoints
                when "Agility"
                    points[ship.data.agility]
                when "Base"
                    if ship?.data.base?
                        switch ship.data.base
                            when "Medium"
                                points[1]
                            when "Large"
                                points[2]
                            when "Huge"
                                points[3]
                    else
                        points[0]
                when "Initiative"
                    points[ship.pilot.skill]
                when "Faction"
                    points[data.faction.indexOf(ship.builder.faction)]
        else
            points
            
    updateSelection: (points) ->
        if @data?
            @selector.select2 'data',
            id: @data.id
            text: "#{if @data.display_name then @data.display_name else @data.name} (#{points}#{if @data.variablepoints then '*' else ''})"
        else
            @selector.select2 'data', null

    toString: ->
        if @data?
            "#{if @data.display_name then @data.display_name else @data.name} (#{@getPoints()})"
        else
            "No #{@type}"

    toHTML: (points) ->
        if @data?
            if @data.slot? and @data.slot == "HardpointShip"
                upgrade_slot_font = "hardpoint"
            else
                upgrade_slot_font = (@data.slot ? @type).toLowerCase().replace(/[^0-9a-z]/gi, '')

            match_array = @data.text?match(/(<span.*<\/span>)<br \/><br \/>(.*)/)

            if match_array
                restriction_html = '<div class="card-restriction-container">' + match_array[1] + '</div>'
                text_str = match_array[2]
            else
                restriction_html = ''
                text_str = @data.text

            attackHTML = ""
            if @data.range?
                attackrangebonus = if (@data.rangebonus?) then """<span class="upgrade-attack-rangebonus"><i class="xwing-miniatures-font xwing-miniatures-font-rangebonusindicator"></i></span>""" else ''
                attackStats = $.trim """
                        <span class="upgrade-attack-range">#{@data.range}</span>
                        #{attackrangebonus}
                """
                attackIcon = if (@data.attack?) then $.trim """
                        <span class="info-data info-attack">#{@data.attack}</span>
                        <i class="xwing-miniatures-font xwing-miniatures-font-frontarc"></i>
                """ else if (@data.attackf?) then $.trim """
                        <span class="info-data info-attack">#{@data.attackf}</span>
                        <i class="xwing-miniatures-font xwing-miniatures-font-fullfrontarc"></i>
                """ else if (@data.attackb?) then $.trim """
                        <span class="info-data info-attack">#{@data.attackb}</span>
                        <i class="xwing-miniatures-font xwing-miniatures-font-backarc"></i>
                """ else if (@data.attackt?) then $.trim """
                        <span class="info-data info-attack">#{@data.attackt}</span>
                        <i class="xwing-miniatures-font xwing-miniatures-font-singleturretarc"></i>
                """ else if (@data.attackdt?) then $.trim """
                        <span class="info-data info-attack">#{@data.attackdt}</span>
                        <i class="xwing-miniatures-font xwing-miniatures-font-doubleturretarc"></i>
                """ else if (@data.attackl?) then $.trim """
                        <span class="info-data info-attack">#{@data.attackl}</span>
                        <i class="xwing-miniatures-font xwing-miniatures-font-leftarc"></i>
                """ else if (@data.attackr?) then $.trim """
                        <span class="info-data info-attack">#{@data.attackr}</span>
                        <i class="xwing-miniatures-font xwing-miniatures-font-rightarc"></i>
                """ else if (@data.attackbull?) then $.trim """
                        <span class="info-data info-attack">#{@data.attackbull}</span>
                        <i class="xwing-miniatures-font xwing-miniatures-font-bullseyearc"></i>
                """ else ''
                attackHTML = $.trim """
                    <div class="upgrade-attack">
                        #{attackStats}
                        #{attackIcon}
                    </div>
                """

            if @data.charge?
                recurringicon = ''
                if  @data.recurring?
                    if @data.recurring > 0
                        count = 0
                        while count < @data.recurring
                            recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
                            ++count
                    else
                        count = @data.recurring
                        while count < 0
                            recurringicon += '<sub><i class="fas fa-caret-down"></i></sub>'
                            ++count
                chargeHTML = $.trim """
                    <div class="upgrade-charge">
                        <span class="info-data info-charge">#{@data.charge}</span>
                        <i class="xwing-miniatures-font xwing-miniatures-font-charge"></i>#{recurringicon}
                    </div>
                    """
            else chargeHTML = $.trim ''

            if (@data.force?)
                forcerecurring = 1
                if @data.forcerecurring?
                    forcerecurring = @data.forcerecurring
                count = 0
                recurringicon = ''
                while count < forcerecurring
                    recurringicon += '<sup><i class="fas fa-caret-up"></i></sup>'
                    ++count
                forceHTML = $.trim """
                    <div class="upgrade-force">
                        <span class="info-data info-force">#{@data.force}</span>
                        <i class="xwing-miniatures-font xwing-miniatures-font-forcecharge"></i>#{recurringicon}
                    </div>
                    """
            else forceHTML = $.trim ''
            
            $.trim """
                <div class="upgrade-container">
                    <div class="upgrade-stats">
                        <div class="upgrade-name"><i class="xwing-miniatures-font xwing-miniatures-font-#{upgrade_slot_font}"></i>#{if @data.display_name then @data.display_name else @data.name}</div>
                        <div class="mask">
                            <div class="outer-circle">
                                <div class="inner-circle upgrade-points">#{points}</div>
                            </div>
                        </div>
                        #{restriction_html}
                    </div>
                    #{attackHTML}
                    #{chargeHTML}
                    #{forceHTML}
                    <div class="upgrade-text">#{text_str}</div>
                    <div style="clear: both;"></div>
                </div>
            """
        else
            ''

    toTableRow: (points) ->
        if @data?
            $.trim """
                <tr class="simple-addon">
                    <td class="name">#{if @data.display_name then @data.display_name else @data.name}</td>
                    <td class="points">#{points}</td>
                </tr>
            """
        else
            ''

    toSimpleCopy: (points) ->
        if @data?
            """#{@data.name} (#{points})    \n"""
        else
            null
            
    toRedditText: (points) ->
        if @data?
            """*&nbsp;#{@data.name} (#{points})*    \n"""
        else
            null

    toTTSText: () ->
        if @data?
            """#{exportObj.toTTS(@data.name)}"""
        else
            null

    toSerialized: ->
        """#{@serialization_code}.#{@data?.id ? -1}"""

    unequipOtherUpgrades: ->
        for slot in @data?.unequips_upgrades ? []
            for upgrade in @ship.upgrades
                continue if not exportObj.slotsMatching(upgrade.slot, slot) or upgrade == this or not upgrade.isOccupied()
                upgrade.setData null
                break

    isOccupied: ->
        @data? or @occupied_by?

    occupyOtherUpgrades: ->
        checkupgrades = []
        if @ship.builder.isXwa and @data?.also_occupies_upgrades_xwa?
            checkupgrades = @data?.also_occupies_upgrades_xwa
        else
            if @data?.also_occupies_upgrades?
                checkupgrades = @data?.also_occupies_upgrades

        for slot in checkupgrades
            for upgrade in @ship.upgrades
                continue if not exportObj.slotsMatching(upgrade.slot, slot) or upgrade == this or upgrade.isOccupied()
                @occupy upgrade
                break

    deoccupyOtherUpgrades: ->
        for upgrade in @occupying
            @deoccupy upgrade

    occupy: (upgrade) ->
        upgrade.occupied_by = this
        upgrade.selector.select2 'enable', false
        @occupying.push upgrade

    deoccupy: (upgrade) ->
        upgrade.occupied_by = null
        upgrade.selector.select2 'enable', true

    occupiesAnUpgradeSlot: (upgradeslot) ->
        for upgrade in @ship.upgrades
            continue if not exportObj.slotsMatching(upgrade.slot, upgradeslot) or upgrade == this or upgrade.data?
            if upgrade.occupied_by? and upgrade.occupied_by == this
                return true
        false

    toXWS: (upgrade_dict) ->
        (upgrade_dict[exportObj.toXWSUpgrade[@data.slot] ? @data.slot.canonicalize()] ?= []).push (@data.xws ? @data.canonical_name)

class exportObj.Upgrade extends GenericAddon
    constructor: (args) ->
        # args
        super args
        @slot = args.slot
        @type = 'Upgrade'
        @dataById = exportObj.upgradesById
        @dataByName = exportObj.upgrades
        @serialization_code = 'U'

        @setupSelector()

    setupSelector: ->
        super
            width: '100%'
            placeholder: @placeholderMod_func(exportObj.translate 'ui', 'upgradePlaceholder', @slot)
            allowClear: true
            query: (query) =>
                data = {results: []}
                data.results = @ship.builder.getAvailableUpgradesIncluding(@slot, @data, @ship, this, query.term, @filter_func)
                query.callback(data)

class exportObj.RestrictedUpgrade extends exportObj.Upgrade
    constructor: (args) ->
        super args
        @serialization_code = 'u'
        if args.auto_equip?
            @setById args.auto_equip

class exportObj.QuickbuildUpgrade extends GenericAddon
    constructor: (args) ->
        super args
        @slot = args.slot
        @type = 'Upgrade'
        @dataById = exportObj.upgradesById
        @dataByName = exportObj.upgrades
        @serialization_code = 'U'
        @upgrade = args.upgrade
        @setupSelector()

    setupSelector: ->
        super
            width: '100%'
            allowClear: false
            query: (query) =>
                data = {
                    results: [{
                            id: @upgrade.id
                            text: if @upgrade.display_name then @upgrade.display_name else @upgrade.name
                            points: 0
                            name: @upgrade.name
                            display_name: @upgrade.display_name
                        }]
                }
                query.callback(data)

    getPoints: (args) ->
        0
            
    updateSelection: (args) ->
        if @data?
            @selector.select2 'data',
            id: @data.id
            text: "#{if @data.display_name then @data.display_name else @data.name}"
        else
            @selector.select2 'data', null
            
        

SERIALIZATION_CODE_TO_CLASS =
    'U': exportObj.Upgrade
    'u': exportObj.RestrictedUpgrade
