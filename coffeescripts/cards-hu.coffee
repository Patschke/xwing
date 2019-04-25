exportObj = exports ? this

exportObj.codeToLanguage ?= {}
exportObj.codeToLanguage.hu = 'Magyar'

exportObj.translations ?= {}
# This is here mostly as a template for other languages.
exportObj.translations.Magyar =
    slot:
        "Astromech": "Astromech"
        "Force": "Erő"
        "Bomb": "Bomba"
        "Cannon": "Ágyú"
        "Crew": "Személyzet"
        "Missile": "Rakéta"
        "Sensor": "Szenzor"
        "Torpedo": "Torpedó"
        "Turret": "Lövegtorony"
        "Hardpoint": "Fegyverfelfüggesztés"
        "Illicit": "Tiltott"
        "Configuration": "Konfiguráció"
        "Talent": "Talentum"
        "Modification": "Módosítás"
        "Gunner": "Fegyverzet kezelő"
        "Device": "Eszköz"
        "Tech": "Tech"
        "Title": "Nevesítés"
    sources: # needed?
        "Second Edition Core Set": "Second Edition Core Set"
        "Rebel Alliance Conversion Kit": "Rebel Alliance Conversion Kit"
        "Galactic Empire Conversion Kit": "Galactic Empire Conversion Kit"
        "Scum and Villainy Conversion Kit": "Scum and Villainy Conversion Kit"
        "T-65 X-Wing Expansion Pack": "T-65 X-Wing Expansion Pack"
        "BTL-A4 Y-Wing Expansion Pack": "BTL-A4 Y-Wing Expansion Pack"
        "TIE/ln Fighter Expansion Pack": "TIE/ln Fighter Expansion Pack"
        "TIE Advanced x1 Expansion Pack": "TIE Advanced x1 Expansion Pack"
        "Slave 1 Expansion Pack": "Slave 1 Expansion Pack"
        "Fang Fighter Expansion Pack": "Fang Fighter Expansion Pack"
        "Lando's Millennium Falcon Expansion Pack": "Lando's Millennium Falcon Expansion Pack"
        "Saw's Renegades Expansion Pack": "Saw's Renegades Expansion Pack"
        "TIE Reaper Expansion Pack": "TIE Reaper Expansion Pack"
    ui:
        shipSelectorPlaceholder: "Válassz egy hajót"
        pilotSelectorPlaceholder: "Válassz egy pilótát"
        upgradePlaceholder: (translator, language, slot) ->
            "Nincs #{translator language, 'slot', slot} fejlesztés"
        modificationPlaceholder: "Nincs módosítás"
        titlePlaceholder: "Nincs nevesítés"
        upgradeHeader: (translator, language, slot) ->
            "#{translator language, 'slot', slot} fejlesztés"
        unreleased: "kiadatlan"
        epic: "epikus"
        limited: "korlátozott"
    byCSSSelector:
        # Warnings
        '.unreleased-content-used .translated': 'Ez a raj kiadatlan tartalmat használ!'
        '.loading-failed-container .translated': 'It appears that you followed a broken link. No squad could be loaded!'
        '.collection-invalid .translated': 'Ez a lista nem vihető pályára a készletedből!'
        '.ship-number-invalid-container .translated': 'A tournament legal squad must contain 2-8 ships!'
        # Type selector
        '.game-type-selector option[value="standard"]': 'Kiterjesztett'
        '.game-type-selector option[value="hyperspace"]': 'Hyperspace'
        '.game-type-selector option[value="custom"]': 'Egyéni'
        # Card browser
        '.xwing-card-browser option[value="name"]': 'Név'
        '.xwing-card-browser option[value="source"]': 'Forrás'
        '.xwing-card-browser option[value="type-by-points"]': 'Típus (pont szerint)'
        '.xwing-card-browser option[value="type-by-name"]': 'Típus (név szerint)'
        '.xwing-card-browser .translate.select-a-card': 'Válassz a bal oldalon lévő kártyákból.'
        '.xwing-card-browser .translate.sort-cards-by': 'Sort cards by'
        # Info well
        '.info-well .info-ship td.info-header': 'Hajó'
        '.info-well .info-skill td.info-header': 'Kezdeményezés'
        '.info-well .info-actions td.info-header': 'Akciók'
        '.info-well .info-upgrades td.info-header': 'Fejlesztések'
        '.info-well .info-range td.info-header': 'Távolság'
        # Squadron edit buttons
        '.clear-squad' : 'Új raj'
        '.save-list' : '<i class="fa fa-floppy-o"></i>&nbsp;Mentés'
        '.save-list-as' : '<i class="fa fa-files-o"></i>&nbsp;Mentés mint…'
        '.delete-list' : '<i class="fa fa-trash-o"></i>&nbsp;Törlés'
        '.backend-list-my-squads' : 'Raj betöltés'
        '.view-as-text' : '<span class="hidden-phone"><i class="fa fa-print"></i>&nbsp;Nyomtatás/Szövegnézet </span>'
        '.randomize' : '<i class="fa fa-random"></i>&nbsp;Random!'
        '.randomize-options' : 'Randomizer opciók…'
        '.notes-container > span' : 'Jegyzetek'
        # Print/View modal
        '.bbcode-list' : 'Copy the BBCode below and paste it into your forum post.<textarea></textarea><button class="btn btn-copy">Másolás</button>'
        '.html-list' : '<textarea></textarea><button class="btn btn-copy">Másolás</button>'
        '.vertical-space-checkbox' : """Hagyj helyet a sérülés és fejlesztéskártyáknak nyomtatáskor <input type="checkbox" class="toggle-vertical-space" />"""
        '.color-print-checkbox' : """Színes nyomtatás <input type="checkbox" class="toggle-color-print" checked="checked" />"""
        '.print-list' : '<i class="fa fa-print"></i>&nbsp;Nyomtatás'
        # Randomizer options
        '.do-randomize' : 'Randomize!'
        # Top tab bar
        '#browserTab' : 'Kártya tallózó'
        '#aboutTab' : 'Rólunk'
        # Obstacles
        '.choose-obstacles' : 'Válassz akadályt'
        '.choose-obstacles-description' : 'Choose up to three obstacles to include in the permalink for use in external programs. (This feature is in BETA; support for displaying which obstacles were selected in the printout is not yet supported.)'
        '.coreasteroid0-select' : 'Core Asteroid 0'
        '.coreasteroid1-select' : 'Core Asteroid 1'
        '.coreasteroid2-select' : 'Core Asteroid 2'
        '.coreasteroid3-select' : 'Core Asteroid 3'
        '.coreasteroid4-select' : 'Core Asteroid 4'
        '.coreasteroid5-select' : 'Core Asteroid 5'
        '.yt2400debris0-select' : 'YT2400 Debris 0'
        '.yt2400debris1-select' : 'YT2400 Debris 1'
        '.yt2400debris2-select' : 'YT2400 Debris 2'
        '.vt49decimatordebris0-select' : 'VT49 Debris 0'
        '.vt49decimatordebris1-select' : 'VT49 Debris 1'
        '.vt49decimatordebris2-select' : 'VT49 Debris 2'
        '.core2asteroid0-select' : 'Force Awakens Asteroid 0'
        '.core2asteroid1-select' : 'Force Awakens Asteroid 1'
        '.core2asteroid2-select' : 'Force Awakens Asteroid 2'
        '.core2asteroid3-select' : 'Force Awakens Asteroid 3'
        '.core2asteroid4-select' : 'Force Awakens Asteroid 4'
        '.core2asteroid5-select' : 'Force Awakens Asteroid 5'
        # Collection
        '.collection': '<i class="fa fa-folder-open hidden-phone hidden-tabler"></i>&nbsp;Gyűjteményed'

    singular:
        'pilots': 'Pilóta'
        'modifications': 'Módosítás'
        'titles': 'Nevesítés'
        'ships' : 'Ship'
    types:
        'Pilot': 'Pilóta'
        'Modification': 'Módosítás'
        'Title': 'Nevesíés'
        'Ship' : 'Ship'

exportObj.cardLoaders ?= {}
exportObj.cardLoaders.Magyar = () ->
    exportObj.cardLanguage = 'Magyar'

    exportObj.renameShip """YT-1300""", """Modified YT-1300 Light Freighter"""
    exportObj.renameShip """StarViper""", """StarViper-class Attack Platform"""
    exportObj.renameShip """Scurrg H-6 Bomber""", """Scurrg H-6 Bomber"""
    exportObj.renameShip """YT-2400""", """YT-2400 Light Freighter"""
    exportObj.renameShip """Auzituck Gunship""", """Auzituck Gunship"""
    exportObj.renameShip """Kihraxz Fighter""", """Kihraxz Fighter"""
    exportObj.renameShip """Sheathipede-Class Shuttle""", """Sheathipede-class Shuttle"""
    exportObj.renameShip """Quadjumper""", """Quadrijet Transfer Spacetug"""
    exportObj.renameShip """Firespray-31""", """Firespray-class Patrol Craft"""
    exportObj.renameShip """TIE Fighter""", """TIE/ln Fighter"""
    exportObj.renameShip """Y-Wing""", """BTL-A4 Y-Wing"""
    exportObj.renameShip """TIE Advanced""", """TIE Advanced x1"""
    exportObj.renameShip """Alpha-Class Star Wing""", """Alpha-class Star Wing"""
    exportObj.renameShip """U-Wing""", """UT-60D U-Wing"""
    exportObj.renameShip """TIE Striker""", """TIE/sk Striker"""
    exportObj.renameShip """B-Wing""", """A/SF-01 B-Wing"""
    exportObj.renameShip """TIE Defender""", """TIE/D Defender"""
    exportObj.renameShip """TIE Bomber""", """TIE/sa Bomber"""
    exportObj.renameShip """TIE Punisher""", """TIE/ca Punisher"""
    exportObj.renameShip """Aggressor""", """Aggressor Assault Fighter"""
    exportObj.renameShip """G-1A Starfighter""", """G-1A Starfighter"""
    exportObj.renameShip """VCX-100""", """VCX-100 Light Freighter"""
    exportObj.renameShip """YV-666""", """YV-666 Light Freighter"""
    exportObj.renameShip """TIE Advanced Prototype""", """TIE Advanced v1"""
    exportObj.renameShip """Lambda-Class Shuttle""", """Lambda-class T-4a Shuttle"""
    exportObj.renameShip """TIE Phantom""", """TIE/ph Phantom"""
    exportObj.renameShip """VT-49 Decimator""", """VT-49 Decimator"""
    exportObj.renameShip """TIE Aggressor""", """TIE/ag Aggressor"""
    exportObj.renameShip """K-Wing""", """BTL-S8 K-Wing"""
    exportObj.renameShip """ARC-170""", """ARC-170 Starfighter"""
    exportObj.renameShip """Attack Shuttle""", """Attack Shuttle"""
    exportObj.renameShip """X-Wing""", """T-65 X-Wing"""
    exportObj.renameShip """HWK-290""", """HWK-290 Light Freighter"""
    exportObj.renameShip """A-Wing""", """RZ-1 A-Wing"""
    exportObj.renameShip """Fang Fighter""", """Fang Fighter"""
    exportObj.renameShip """Z-95 Headhunter""", """Z-95-AF4 Headhunter"""
    exportObj.renameShip """M12-L Kimogila Fighter""", """M12-L Kimogila Fighter"""
    exportObj.renameShip """E-Wing""", """E-Wing"""
    exportObj.renameShip """TIE Interceptor""", """TIE Interceptor"""
    exportObj.renameShip """Lancer-Class Pursuit Craft""", """Lancer-class Pursuit Craft"""
    exportObj.renameShip """TIE Reaper""", """TIE Reaper"""
    exportObj.renameShip """JumpMaster 5000""", """JumpMaster 5000"""
    exportObj.renameShip """M3-A Interceptor""", """M3-A Interceptor"""
    exportObj.renameShip """Scavenged YT-1300""", """Scavenged YT-1300 Light Freighter"""
    exportObj.renameShip """Escape Craft""", """Escape Craft"""

    # Names don't need updating, but text needs to be set
    pilot_translations =
        "Academy Pilot":
           display_name: """Academy Pilot"""
           text: """ """
        "Alpha Squadron Pilot":
           display_name: """Alpha Squadron Pilot"""
           text: """<strong>Autothrusters:</strong> Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BARRELROLL% vagy piros %BOOST% akciót."""
        "Bandit Squadron Pilot":
           display_name: """Bandit Squadron Pilot"""
           text: """ """
        "Baron of the Empire":
           display_name: """Baron of the Empire"""
           text: """ """
        "Binayre Pirate":
           display_name: """Binayre Pirate"""
           text: """ """
        "Black Squadron Ace":
           display_name: """Black Squadron Ace"""
           text: """ """
        "Black Squadron Scout":
           display_name: """Black Squadron Scout"""
           text: """<sasmall><strong>Adaptive Ailerons:</strong> Mielőtt felfednéd a tárcsád, ha nem vagy stresszes, végre <b>kell</b> hajtanod egy fehér [1&nbsp;%BANKLEFT%), [1&nbsp;%STRAIGHT%] vagy [1&nbsp;%BANKRIGHT%] manővert.</sasmall>"""
        "Black Sun Ace":
           display_name: """Black Sun Ace"""
           text: """ """
        "Black Sun Assassin":
           display_name: """Black Sun Assassin"""
           text: """<sasmall><strong>Microthrusters:</strong> Amikor orsózást hajtasz végre, a %BANKLEFT% vagy %BANKRIGHT% sablont <b>kell</b> használnod a %STRAIGHT% helyett.</sasmall>"""
        "Black Sun Enforcer":
           display_name: """Black Sun Enforcer"""
           text: """<sasmall><strong>Microthrusters:</strong> Amikor orsózást hajtasz végre, a %BANKLEFT% vagy %BANKRIGHT% sablont <b>kell</b> használnod a %STRAIGHT% helyett.</sasmall>"""
        "Black Sun Soldier":
           display_name: """Black Sun Soldier"""
           text: """ """
        "Blade Squadron Veteran":
           display_name: """Blade Squadron Veteran"""
           text: """ """
        "Blue Squadron Escort":
           display_name: """Blue Squadron Escort"""
           text: """ """
        "Blue Squadron Pilot":
           display_name: """Blue Squadron Pilot"""
           text: """ """
        "Blue Squadron Scout":
           display_name: """Blue Squadron Scout"""
           text: """ """
        "Bounty Hunter":
           display_name: """Bounty Hunter"""
           text: """ """
        "Cartel Executioner":
           display_name: """Cartel Executioner"""
           text: """<sasmall> <strong>Dead to Rights:</strong> Amikor végrehajtasz egy támadást, ha a védekező benne van a %BULLSEYEARC% tűzívedben, a védekezőkockák nem módosíthatók zöld jelzőkkel.</sasmall>"""
        "Cartel Marauder":
           display_name: """Cartel Marauder"""
           text: """ """
        "Cartel Spacer":
           display_name: """Cartel Spacer"""
           text: """<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Cavern Angels Zealot":
           display_name: """Cavern Angels Zealot"""
           text: """ """
        "Contracted Scout":
           display_name: """Contracted Scout"""
           text: """ """
        "Crymorah Goon":
           display_name: """Crymorah Goon"""
           text: """ """
        "Cutlass Squadron Pilot":
           display_name: """Cutlass Squadron Pilot"""
           text: """ """
        "Delta Squadron Pilot":
           display_name: """Delta Squadron Pilot"""
           text: """<strong>Full Throttle:</strong> Miután teljesen végrehajtasz egy 3-5 sebességű manővert, végrehajthatsz egy %EVADE% akciót."""
        "Freighter Captain":
           display_name: """Freighter Captain"""
           text: """"""
        "Gamma Squadron Ace":
           display_name: """Gamma Squadron Ace"""
           text: """<strong>Nimble Bomber:</strong> Ha ledobnál egy eszközt a %STRAIGHT% sablon segítségével, használhatod az azonos sebességű %BANKLEFT% vagy %BANKRIGHT% sablonokat helyette."""
        "Gand Findsman":
           display_name: """Gand Findsman"""
           text: """ """
        "Gold Squadron Veteran":
           display_name: """Gold Squadron Veteran"""
           text: """ """
        "Gray Squadron Bomber":
           display_name: """Gray Squadron Bomber"""
           text: """ """
        "Green Squadron Pilot":
           display_name: """Green Squadron Pilot"""
           text: """<sasmall><strong>Vectored Thrusters:</strong> Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BOOST% akciót.</sasmall>"""
        "Hired Gun":
           display_name: """Hired Gun"""
           text: """ """
        "Imdaar Test Pilot":
           display_name: """Imdaar Test Pilot"""
           text: """<strong>Stygium Array:</strong> Miután kijössz az álcázásból végrehajthatsz egy %EVADE% akciót. A Vége fázis elején elkölthetsz 1 kitérés jelzőt, hogy kapj egy álcázás jelzőt."""
        "Inquisitor":
           display_name: """Inquisitor"""
           text: """ """
        "Jakku Gunrunner":
           display_name: """Jakku Gunrunner"""
           text: """<strong>Spacetug Tractor Array:</strong> <strong>Akció:</strong>: Válassz egy hajót a %FRONTARC% tűzívedben 1-es távolságban. Az a hajó kap 1 vonósugár jelzőt vagy 2 vonósugár jelzőt, ha benne van a %BULLSEYEARC% tűzívedben 1-es távolságban."""
        "Kashyyyk Defender":
           display_name: """Kashyyyk Defender"""
           text: """ """
        "Knave Squadron Escort":
           display_name: """Knave Squadron Escort"""
           text: """<sasmall><strong>Experimental Scanners:</strong> 3-as távolságon túl is bemérhetsz. Nem mérhetsz be 1-es távolságra.</sasmall>"""
        "Lok Revenant":
           display_name: """Lok Revenant"""
           text: """ """
        "Lothal Rebel":
           display_name: """Lothal Rebel"""
           text: """<strong>Tail Gun:</strong> ha van bedokkolt hajód, használhatod az elsődleges %REARARC% fegyvered, ugyanolyan támadási értékkel, mint a dokkolt hajó elsődleges %FRONTARC% támadási értéke."""
        "Nu Squadron Pilot":
           display_name: """Nu Squadron Pilot"""
           text: """ """
        "Obsidian Squadron Pilot":
           display_name: """Obsidian Squadron Pilot"""
           text: """ """
        "Omicron Group Pilot":
           display_name: """Omicron Group Pilot"""
           text: """ """
        "Onyx Squadron Ace":
           display_name: """Onyx Squadron Ace"""
           text: """<strong>Full Throttle:</strong> Miután teljesen végrehajtasz egy 3-5 sebességű manővert, végrehajthatsz egy %EVADE% akciót."""
        "Onyx Squadron Scout":
           display_name: """Onyx Squadron Scout"""
           text: """ """
        "Outer Rim Smuggler":
           display_name: """Outer Rim Smuggler"""
           text: """ """
        "Partisan Renegade":
           display_name: """Partisan Renegade"""
           text: """ """
        "Patrol Leader":
           display_name: """Patrol Leader"""
           text: """ """
        "Phoenix Squadron Pilot":
           display_name: """Phoenix Squadron Pilot"""
           text: """<sasmall><strong>Vectored Thrusters:</strong> Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BOOST% akciót.</sasmall>"""
        "Planetary Sentinel":
           display_name: """Planetary Sentinel"""
           text: """<sasmall><strong>Adaptive Ailerons:</strong> Mielőtt felfednéd a tárcsád, ha nem vagy stresszes, végre <b>kell</b> hajtanod egy fehér [1&nbsp;%BANKLEFT%), [1&nbsp;%STRAIGHT%] vagy [1&nbsp;%BANKRIGHT%] manővert.</sasmall>"""
        "Rebel Scout":
           display_name: """Rebel Scout"""
           text: """ """
        "Red Squadron Veteran":
           display_name: """Red Squadron Veteran"""
           text: """ """
        "Rho Squadron Pilot":
           display_name: """Rho Squadron Pilot"""
           text: """ """
        "Rogue Squadron Escort":
           display_name: """Rogue Squadron Escort"""
           text: """<sasmall><strong>Experimental Scanners:</strong> 3-as távolságon túl is bemérhetsz. Nem mérhetsz be 1-es távolságra.</sasmall>"""
        "Saber Squadron Ace":
           display_name: """Saber Squadron Ace"""
           text: """<strong>Autothrusters:</strong> Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BARRELROLL% vagy piros %BOOST% akciót."""
        "Scarif Base Pilot":
           display_name: """Scarif Base Pilot"""
           text: """<sasmall><strong>Adaptive Ailerons:</strong> Mielőtt felfednéd a tárcsád, ha nem vagy stresszes, végre <b>kell</b> hajtanod egy fehér [1&nbsp;%BANKLEFT%), [1&nbsp;%STRAIGHT%] vagy [1&nbsp;%BANKRIGHT%] manővert.</sasmall>"""
        "Scimitar Squadron Pilot":
           display_name: """Scimitar Squadron Pilot"""
           text: """<strong>Nimble Bomber:</strong> Ha ledobnál egy eszközt a %STRAIGHT% sablon segítségével, használhatod az azonos sebességű %BANKLEFT% vagy %BANKRIGHT% sablonokat helyette."""
        "Shadowport Hunter":
           display_name: """Shadowport Hunter"""
           text: """ """
        "Sienar Specialist":
           display_name: """Sienar Specialist"""
           text: """ """
        "Sigma Squadron Ace":
           display_name: """Sigma Squadron Ace"""
           text: """<strong>Stygium Array:</strong> Miután kijössz az álcázásból végrehajthatsz egy %EVADE% akciót. A Vége fázis elején elkölthetsz 1 kitérés jelzőt, hogy kapj egy álcázás jelzőt."""
        "Skull Squadron Pilot":
           display_name: """Skull Squadron Pilot"""
           text: """<sasmall><strong>Concordia Faceoff:</strong> Amikor védekezel, ha a támadás 1-es távolságban történik és benne vagy a támadó %FRONTARC% tűzívében, megváltoztathatod 1 dobás eredményed %EVADE% eredményre.</sasmall>"""
        "Spice Runner":
           display_name: """Spice Runner"""
           text: """ """
        "Storm Squadron Ace":
           display_name: """Storm Squadron Ace"""
           text: """<sasmall><strong>Advanced Targeting Computer:</strong> Amikor végrehajtasz egy elsődleges támadást egy olyan védekező ellen, akit bemértél, 1-gyel több támadókockával dobj és változtasd 1&nbsp;%HIT% eredményed %CRIT% eredményre.</sasmall>"""
        "Tala Squadron Pilot":
           display_name: """Tala Squadron Pilot"""
           text: """ """
        "Tansarii Point Veteran":
           display_name: """Tansarii Point Veteran"""
           text: """<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Tempest Squadron Pilot":
           display_name: """Tempest Squadron Pilot"""
           text: """<sasmall><strong>Advanced Targeting Computer:</strong> Amikor végrehajtasz egy elsődleges támadást egy olyan védekező ellen, akit bemértél, 1-gyel több támadókockával dobj és változtasd 1&nbsp;%HIT% eredményed %CRIT% eredményre.</sasmall>"""
        "Trandoshan Slaver":
           display_name: """Trandoshan Slaver"""
           text: """ """
        "Warden Squadron Pilot":
           display_name: """Warden Squadron Pilot"""
           text: """ """
        "Wild Space Fringer":
           display_name: """Wild Space Fringer"""
           text: """<strong>Sensor Blindspot:</strong> Amikor elsődleges támadást hajtasz végre 0-1-es távolságban, nem érvényesül a 0-1-es távolságért járó bónusz és 1-gyel kevesebb támadókockával dobsz."""
        "Zealous Recruit":
           display_name: """Zealous Recruit"""
           text: """<sasmall><strong>Concordia Faceoff:</strong> Amikor védekezel, ha a támadás 1-es távolságban történik és benne vagy a támadó %FRONTARC% tűzívében, megváltoztathatod 1 dobás eredményed %EVADE% eredményre.</sasmall>"""
        "4-LOM":
           display_name: """4-LOM"""
           text: """Miután teljesen végrehajtasz egy piros manővert, kapsz 1 kalkuláció jelzőt. A Vége fázis elején választhatsz 1 hajót 0-1-es távolságban. Ha így teszel, add át 1 stressz jelződ annak a hajónak."""
        "Nashtah Pup":
           display_name: """Nashtah Pup"""
           text: """Csak vészhelyzet esetén válhatsz le az anyahajóról. Ebben az esetben megkapod a megsemmisült baráti Hound's Tooth pilóta nevet, kezdeményezést, pilóta képességet és hajó %CHARGE% jelzőt. %LINEBREAK% <strong>Escape Craft:</strong> <strong>Setup:</strong> <strong>Hound’s Tooth</strong> szükséges. A <strong>Hound’s Tooth</strong>-ra dokkolva <b>kell</b> kezdened a játékot."""
        "AP-5":
           display_name: """AP-5"""
           text: """Amikor koordinálsz, ha a kiválasztott hajónak pontosan 1 stressz jelzője van, az végrehajthat akciókat.%LINEBREAK%<sasmall><strong>Comms Shuttle:</strong> Amikor dokkolva vagy az anyahajód %COORDINATE% akció lehetőséget kap. Az anyahajód aktiválása előtt végrehajthat egy %COORDINATE% akciót.</sasmall>"""
        "Airen Cracken":
           display_name: """Airen Cracken"""
           text: """Miután végrehajtasz egy támadást, választhatsz 1 baráti hajót 1-es távolságban. Az a hajó végrehajthat egy akciót, pirosként kezelve."""
        "Arvel Crynyd":
           display_name: """Arvel Crynyd"""
           text: """Végrehajthatsz elsődleges támadást 0-ás távolságban. Ha egy %BOOST% akcióddal átfedésbe kerülsz egy másik hajóval, úgy hajtsd végre, mintha csak részleges manőver lett volna. %LINEBREAK% VECTORED THRUSTERS: Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BOOST% gyorsítás akciót."""
        "Asajj Ventress":
           display_name: """Asajj Ventress"""
           text: """Az Ütközet fázis elején választhatsz 1 ellenséges hajót a %SINGLETURRETARC% tűzívedben 0-2-es távolságban és költs 1&nbsp;%FORCE% jelzőt. Ha így teszel, az a hajó kap 1 stressz jelzőt, hacsak nem távolít el 1 zöld jelzőt."""
        "Autopilot Drone":
           display_name: """Autopilot Drone"""
           text: """<strong>Rigged Energy Cells:</strong> A Rendszer fázis alatt, ha nem vagy dokkolva, elvesztesz 1&nbsp;%CHARGE% jelzőt. Az aktivációs fázis végén, ha már nincs %CHARGE% jelződ, megsemmisülsz. Mielőtt levennéd a hajód minden 0-1-es távolságban lévő hajó elszenved 1&nbsp;%CRIT% sérülést."""
        "Benthic Two Tubes":
           display_name: """Benthic Two Tubes"""
           text: """Miután végrehajtasz egy %FOCUS% akciót, átrakhatod 1 fókusz jelződ egy baráti hajóra 1-2-es távolságban."""
        "Biggs Darklighter":
           display_name: """Biggs Darklighter"""
           text: """Amikor baráti hajó védekezik tőled 0-1-es távolságban, az <strong>Eredmények semlegesítése</strong> lépés előtt, ha a támadó tűzívében vagy, elszenvedhetsz 1&nbsp;%HIT% vagy %CRIT% találatot, hogy hatástalaníts 1 azzal egyező találatot."""
        "Boba Fett":
           display_name: """Boba Fett"""
           text: """Amikor védekezel vagy végrehajtasz egy támadást, újradobhatsz 1 kockát, minden egyes 0-1-es távolságban lévő ellenséges hajó után."""
        "Bodhi Rook":
           display_name: """Bodhi Rook"""
           text: """Baráti hajók bemérhetnek más baráti hajóktól 0-3-as távolságban lévő objektumokat."""
        "Bossk":
           display_name: """Bossk"""
           text: """Amikor végrehajtasz egy elsődleges támadást, az <strong>Eredmények semlegesítése</strong> lépés után, elkölthetsz egy %CRIT% eredményt, hogy hozzáadj 2 %HIT% eredményt a dobásodhoz."""
        "Braylen Stramm":
           display_name: """Braylen Stramm"""
           text: """Amikor védekezel vagy végrehajtasz egy támadást, ha stresszes vagy, újradobhatod legfeljebb 2 kockádat."""
        "Captain Feroph":
           display_name: """Captain Feroph"""
           text: """Amikor védekezel, ha a támadónak nincs zöld jelzője, megváltoztathatod 1 üres vagy %FOCUS% dobásod %EVADE% eredményre.%LINEBREAK%<sasmall><strong>Adaptive Ailerons:</strong> Mielőtt felfednéd a tárcsád, ha nem vagy stresszes, végre <b>kell</b> hajtanod egy fehér [1&nbsp;%BANKLEFT%), [1&nbsp;%STRAIGHT%] vagy [1&nbsp;%BANKRIGHT%] manővert.</sasmall>"""
        "Captain Jonus":
           display_name: """Captain Jonus"""
           text: """Amikor egy baráti hajó 0-1-es távolságban végrehajt egy %TORPEDO% vagy %MISSILE% támadást, az újradobhat legfeljebb 2 támadókockát.%LINEBREAK%<strong>Nimble Bomber:</strong> Ha ledobnál egy eszközt a %STRAIGHT% sablon segítségével, használhatod az azonos sebességű %BANKLEFT% vagy %BANKRIGHT% sablonokat helyette."""
        "Captain Jostero":
           display_name: """Captain Jostero"""
           text: """Miután egy ellenséges hajó sérülést szenved és nem védekezett, végrehajthatsz egy bónusz támadást ellene."""
        "Captain Kagi":
           display_name: """Captain Kagi"""
           text: """Az Ütközet fázis elején választhatsz egy vagy több baráti hajót 0-3-es távolságban. Ha így teszel, tedd át az összes ellenséges bemérés jelzőt a kiválasztott hajókról magadra."""
        "Captain Nym":
           display_name: """Captain Nym"""
           text: """Mielőtt egy baráti bomba vagy akna felrobbanna, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy megakadályozd a felrobbanását.%LINEBREAK%Mikor egy támadás ellen védekezel, amely akadályozott egy bomba vagy akna által, 1-gyel több védekezőkockával dobj."""
        "Captain Oicunn":
           display_name: """Captain Oicunn"""
           text: """Végrehajthatsz elsődleges támadást 0-ás távolságban."""
        "Captain Rex":
           display_name: """Captain Rex"""
           text: """Miután végrehajtasz egy támadást, jelöld meg a védekezőt a <strong>Suppressive Fire</strong> kondícióval."""
        "Cassian Andor":
           display_name: """Cassian Andor"""
           text: """Az Aktivációs fázis elején választhatsz 1 baráti hajót 1-3-as távolságban. Ha így teszel, az a hajó eltávolít 1 stressz jelzőt."""
        "Chewbacca":
           display_name: """Chewbacca"""
           text: """Mielőtt felfordított sebzéskártyát kapnál, elkölthetsz 1&nbsp;%CHARGE%-et, hogy a lapot képpel lefelé húzd fel."""
        "Colonel Jendon":
           display_name: """Colonel Jendon"""
           text: """Az Aktivációs fázis elején elkölthetsz 1&nbsp;%CHARGE% jelzőt. Ha így teszel, amikor baráti hajók bemérés jelzőt tesznek fel ebben a körben, 3-as távolságon túl tehetik csak meg a 0-3-as távolság helyett."""
        "Colonel Vessery":
           display_name: """Colonel Vessery"""
           text: """Amikor támadást hajtasz végre egy bemért hajó ellen, miután dobsz a kockákkal, feltehetsz egy bemérés jelzőt a védekezőre.%LINEBREAK%<strong>Full Throttle:</strong> Miután teljesen végrehajtasz egy 3-5 sebességű manővert, végrehajthatsz egy %EVADE% akciót."""
        "Constable Zuvio":
           display_name: """Constable Zuvio"""
           text: """Amikor kidobnál egy eszközt, helyette ki is lőheted egy [1&nbsp;%STRAIGHT%] sablon használatával.%LINEBREAK%<strong>Spacetug Tractor Array:</strong> <strong>Akció:</strong>: Válassz egy hajót a %FRONTARC% tűzívedben 1-es távolságban. Az a hajó kap 1 vonósugár jelzőt vagy 2 vonósugár jelzőt, ha benne van a %BULLSEYEARC% tűzívedben 1-es távolságban."""
        "Corran Horn":
           display_name: """Corran Horn"""
           text: """0-ás kezdeményezésnél végrehajthatsz egy bónusz elsődleges támadást egy ellenséges hajó ellen, aki a %BULLSEYEARC% tűzívedben van. Ha így teszel, a következő Tervezés fázisban kapsz 1 'inaktív fegyverzet' jelzőt.%LINEBREAK%<sasmall><strong>Experimental Scanners:</strong> 3-as távolságon túl is bemérhetsz. Nem mérhetsz be 1-es távolságra.</sasmall>"""
        "Countess Ryad":
           display_name: """Countess Ryad"""
           text: """Amikor végrehajtanál egy %STRAIGHT% manővert, megnövelheted annak nehézségét. Ha így teszel, helyette végrehajthatod mint %KTURN% manőver.%LINEBREAK%<strong>Full Throttle:</strong> Miután teljesen végrehajtasz egy 3-5 sebességű manővert, végrehajthatsz egy %EVADE% akciót."""
        "Dace Bonearm":
           display_name: """Dace Bonearm"""
           text: """Miután egy ellenséges hajó 0-3-as távolságban kap legalább 1 ion jelzőt, elkölthetsz 3&nbsp;%CHARGE% jelzőt. Ha így teszel, az a hajó kap 2 további ion jelzőt."""
        "Dalan Oberos (StarViper)":
           display_name: """Dalan Oberos"""
           text: """Miután teljesen végrehajtasz egy manővert, kaphatsz 1 stressz jelzőt, hogy elforgasd a hajód 90 fokkal.%LINEBREAK% <sasmall><strong>Microthrusters:</strong> Amikor orsózást hajtasz végre, a %BANKLEFT% vagy %BANKRIGHT% sablont <b>kell</b> használnod a %STRAIGHT% helyett.</sasmall>"""
        "Dalan Oberos":
           display_name: """Dalan Oberos"""
           text: """Az Ütközet fázis elején választhatsz 1 pajzzsal rendelkező hajót a %BULLSEYEARC% tűzívedben és elkölthetsz 1&nbsp;%CHARGE% jelzőt. Ha így teszel, az a hajó elveszít egy pajzsot, te pedig visszatöltesz 1 pajzsot.%LINEBREAK%<sasmall><strong>Dead to Rights:</strong> Amikor végrehajtasz egy támadást, ha a védekező benne van a %BULLSEYEARC% tűzívedben, a védekezőkockák nem módosíthatók zöld jelzőkkel.</sasmall>"""
        "Darth Vader":
           display_name: """Darth Vader"""
           text: """Miután végrehajtasz egy akciót, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy végrehajts egy akciót.%LINEBREAK%<sasmall><strong>Advanced Targeting Computer:</strong> Amikor végrehajtasz egy elsődleges támadást egy olyan védekező ellen, akit bemértél, 1-gyel több támadókockával dobj és változtasd 1&nbsp;%HIT% eredményed %CRIT% eredményre.</sasmall>"""
        "Dash Rendar":
           display_name: """Dash Rendar"""
           text: """Amikor mozogsz, hagyd figyelmen kívül az akadályokat.%LINEBREAK%<strong>Sensor Blindspot:</strong> Amikor elsődleges támadást hajtasz végre 0-1-es távolságban, nem érvényesül a 0-1-es távolságért járó bónusz és 1-gyel kevesebb támadókockával dobsz."""
        "Del Meeko":
           display_name: """Del Meeko"""
           text: """Amikor egy baráti 0-2 távolságban védekezik egy sérült támadó ellen, a védekező újradobhat 1 védekezőkockát."""
        "Dengar":
           display_name: """Dengar"""
           text: """Miután védekeztél, ha a támadó benne van a %FRONTARC% tűzívedben, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy végrehajts egy bónusz támadást a támadó ellen."""
        "Drea Renthal":
           display_name: """Drea Renthal"""
           text: """Amikor egy baráti nem-limitált hajó végrehajt egy támadást, ha a védekező benne van a tűzívedben, a támadó újradobhatja 1 támadókockáját."""
        "Edrio Two Tubes":
           display_name: """Edrio Two Tubes"""
           text: """Mielőtt aktiválódnál és van fókuszod, végrehajthatsz egy akciót."""
        "Emon Azzameen":
           display_name: """Emon Azzameen"""
           text: """Ha ki szeretnél dobni egy eszközt az [1&nbsp;%STRAIGHT%] sablonnal, használhatod helyette a [3&nbsp;%TURNLEFT%], [3&nbsp;%STRAIGHT%], vagy [3&nbsp;%TURNRIGHT%] sablont."""
        "Esege Tuketu":
           display_name: """Esege Tuketu"""
           text: """Amikor egy 0-2-es távolságban lévő baráti hajó védekezik vagy támadást hajt végre, elköltheti a te fókusz jelzőidet, mintha a saját hajójáé lenne."""
        "Evaan Verlaine":
           display_name: """Evaan Verlaine"""
           text: """Az Ütközet fázis elején elkölthetsz 1 fókusz jelzőt, hogy kiválassz egy baráti hajót 0-1-es távolságban. Ha így teszel, az a hajó a kör végéig minden védekezésénél 1-gyel több védekezőkockával dob."""
        "Ezra Bridger":
           display_name: """Ezra Bridger"""
           text: """Amikor védekezel vagy támadást hajtasz végre, ha stresszes vagy, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy legfeljebb 2 %FOCUS% eredményt %EVADE% vagy %HIT% eredményre módosíts.%LINEBREAK%<sasmall><strong>Locked and Loaded:</strong> Amikor dokkolva vagy, miután az anyahajód végrehajtott egy elsődleges %FRONTARC% vagy %TURRET% támadást, végrehajthat egy bónusz %REARARC% támadást.</sasmall>"""
        "Ezra Bridger (Sheathipede)":
           display_name: """Ezra Bridger"""
           text: """Amikor védekezel vagy támadást hajtasz végre, ha stresszes vagy, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy legfeljebb 2 %FOCUS% eredményt %EVADE% vagy %HIT% eredményre módosíts.%LINEBREAK%<sasmall><strong>Comms Shuttle:</strong> Amikor dokkolva vagy az anyahajód %COORDINATE% akció lehetőséget kap. Az anyahajód aktiválása előtt végrehajthat egy %COORDINATE% akciót.</sasmall>"""
        "Ezra Bridger (TIE Fighter)":
           display_name: """Ezra Bridger"""
           text: """Amikor védekezel vagy támadást hajtasz végre, ha stresszes vagy, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy legfeljebb 2 %FOCUS% eredményt %EVADE% vagy %HIT% eredményre módosíts."""
        "Fenn Rau (Sheathipede)":
           display_name: """Fenn Rau"""
           text: """Miután egy ellenséges hajó a tűzívedben sorra kerül az Ütközet fázisban, ha nem vagy stresszes, kaphatsz 1 stressz jelzőt. Ha így teszel, az a hajó nem költhet el jelzőt, hogy módosítsa támadókockáit e fázis alatt.%LINEBREAK%<sasmall><strong>Comms Shuttle:</strong> Amikor dokkolva vagy az anyahajód %COORDINATE% akció lehetőséget kap. Az anyahajód aktiválása előtt végrehajthat egy %COORDINATE% akciót.</sasmall>"""
        "Fenn Rau":
           display_name: """Fenn Rau"""
           text: """Amikor védekezel vagy támadást hajtasz végre, ha a támadás 1-es távolságban történik, 1-gyel több kockával dobhatsz.%LINEBREAK%<sasmall><strong>Concordia Faceoff:</strong> Amikor védekezel, ha a támadás 1-es távolságban történik és benne vagy a támadó %FRONTARC% tűzívében, megváltoztathatod 1 dobás eredményed %EVADE% eredményre.</sasmall>"""
        "Garven Dreis (X-Wing)":
           display_name: """Garven Dreis"""
           text: """Miután elköltesz egy fókusz jelzőt, választhatsz 1 baráti hajót 1-3-as távolságban. Az a hajó kap 1 fókusz jelzőt."""
        "Garven Dreis":
           display_name: """Garven Dreis"""
           text: """Miután elköltesz egy fókusz jelzőt, választhatsz 1 baráti hajót 1-3-as távolságban. Az a hajó kap 1 fókusz jelzőt."""
        "Gavin Darklighter":
           display_name: """Gavin Darklighter"""
           text: """Amikor egy baráti hajó végrehajt egy támadást, ha a védekező a %FRONTARC% tűzívedben van, a támadó 1&nbsp;%HIT% eredményét %CRIT% eredményre módosíthatja.%LINEBREAK%<sasmall><strong>Experimental Scanners:</strong> 3-as távolságon túl is bemérhetsz. Nem mérhetsz be 1-es távolságra.</sasmall>"""
        "Genesis Red":
           display_name: """Genesis Red"""
           text: """Miután feltettél egy bemérés jelzőt, le kell venned az összes fókusz és kitérés jelződet, aztán megkapsz annyi fókusz és kitérés jelzőt, ahány a bemért hajónak van.%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Gideon Hask":
           display_name: """Gideon Hask"""
           text: """Amikor végrehajtasz egy támadást sérült védekező ellen, 1-gyel több támadókockával dobhatsz."""
        "Grand Inquisitor":
           display_name: """Grand Inquisitor"""
           text: """Amikor 1-es távolságban védekezel, elkölthetsz 1&nbsp;%FORCE% tokent, hogy megakadályozd az 1-es távolság bónuszt. Amikor támadást hajtasz végre 2-3-as távolságban lévő védekező ellen, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy megkapd az 1-es távolság bónuszt."""
        "Graz":
           display_name: """Graz"""
           text: """Amikor védekezel, ha a támadó mögött vagy, 1-gyel több védekezőkockával dobhatsz. Amikor végrehajtasz egy támadást, ha a védekező mögött vagy, 1-gyel több támadókockával dobhatsz."""
        "Guri":
           display_name: """Guri"""
           text: """Az Ütközet fázis elején, ha legalább 1 ellenséges hajó van 0-1-es távolságban, kaphatsz egy fókusz jelzőt.%LINEBREAK% <sasmall><strong>Microthrusters:</strong> Amikor orsózást hajtasz végre, a %BANKLEFT% vagy %BANKRIGHT% sablont <b>kell</b> használnod a %STRAIGHT% helyett.</sasmall>"""
        "Han Solo":
           display_name: """Han Solo"""
           text: """Miután dobtál, ha 0-1-es távolságban vagy akadálytól, újradobhatod az összes kockádat. Ez nem számít újradobásnak más hatások számára."""
        "Han Solo (Scum)":
           display_name: """Han Solo"""
           text: """Amikor védekezel vagy elsődleges támadást hajtasz vége, ha a támadás akadály által akadályozott, 1-gyel több kockával dobhatsz."""
        "Heff Tobber":
           display_name: """Heff Tobber"""
           text: """Miután egy ellenséges hajó végrehajt egy manővert, ha 0-ás távolságba kerül, végrehajthatsz egy akciót."""
        "Hera Syndulla":
           display_name: """Hera Syndulla"""
           text: """Miután piros vagy kék manővert fedtél fel, átállíthatod manőversablonod egy másik, azonos nehézségű manőverre.%LINEBREAK%<sasmall><strong>Locked and Loaded:</strong> Amikor dokkolva vagy, miután az anyahajód végrehajtott egy elsődleges %FRONTARC% vagy %TURRET% támadást, végrehajthat egy bónusz %REARARC% támadást.</sasmall>"""
        "Hera Syndulla (VCX-100)":
           display_name: """Hera Syndulla"""
           text: """Miután piros vagy kék manővert fedtél fel, átállíthatod manőversablonod egy másik, azonos nehézségű manőverre.%LINEBREAK%<strong>Tail Gun:</strong> ha van bedokkolt hajód, használhatod az elsődleges %REARARC% fegyvered, ugyanolyan támadási értékkel, mint a dokkolt hajó elsődleges %FRONTARC% támadási értéke."""
        "Horton Salm":
           display_name: """Horton Salm"""
           text: """Amikor támadást hajtasz végre, a védekezőtől 0-1-es távolságban lévő minden más baráti hajó után újradobhatsz 1 támadókockát."""
        "IG-88A":
           display_name: """IG-88A"""
           text: """Az Ütközet fázis elején kiválaszthatsz egy %CALCULATE% akcióval rendelkező baráti hajót 1-3-as távolságban. Ha így teszel, add át 1 kalkuláció jelződet neki.%LINEBREAK%<strong>Advanced Droid Brain:</strong> Miután végrehajtasz egy %CALCULATE% akciót, kapsz 1 kalkuláció jelzőt."""
        "IG-88B":
           display_name: """IG-88B"""
           text: """Miután végrehajtasz egy támadást ami nem talált, végrehajthatsz egy bónusz %CANNON% támadást.%LINEBREAK%<strong>Advanced Droid Brain:</strong> Miután végrehajtasz egy %CALCULATE% akciót, kapsz 1 kalkuláció jelzőt."""
        "IG-88C":
           display_name: """IG-88C"""
           text: """Miután végrehajtasz egy %BOOST% akciót, végrehajthatsz egy %EVADE% akciót.%LINEBREAK%<strong>Advanced Droid Brain:</strong> Miután végrehajtasz egy %CALCULATE% akciót, kapsz 1 kalkuláció jelzőt."""
        "IG-88D":
           display_name: """IG-88D"""
           text: """Amikor végrehajtasz egy Segnor's Loop [%SLOOPLEFT% vagy %SLOOPRIGHT%] manővert, használhatsz ugyanazon sebességű másik sablont helyette: vagy megegyező irányú kanyar [%TURNLEFT% vagy %TURNRIGHT%] vagy előre egyenes [%STRAIGHT%] sablont.%LINEBREAK%<strong>Advanced Droid Brain:</strong> Miután végrehajtasz egy %CALCULATE% akciót, kapsz 1 kalkuláció jelzőt."""
        "Ibtisam":
           display_name: """Ibtisam"""
           text: """Miután teljesen végrehajtasz egy manővert, ha stresszes vagy, dobhatsz 1 támadókockával. %HIT% vagy %CRIT% eredmény esetén távolíts el 1 stressz jelzőt."""
        "Iden Versio":
           display_name: """Iden Versio"""
           text: """Mielőtt egy 0-1-es távolságban lévő baráti TIE/ln hajó elszenvedne 1 vagy több sérülést, elkölthetsz 1&nbsp;%CHARGE% jelzőt. Ha így teszel, megakadályozod a sérülést."""
        "Inaldra":
           display_name: """Inaldra"""
           text: """Amikor védekezel vagy támadást hajtasz végre, elszenvedhetsz 1&nbsp;%HIT% sérülést, hogy újradobj bármennyi kockát.%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Jake Farrell":
           display_name: """Jake Farrell"""
           text: """Miután végrehajtasz egy %BARRELROLL% vagy %BOOST% akciót, választhatsz egy baráti hajót 0-1-es távolságban. Az a hajó végrehajthat egy %FOCUS% akciót.%LINEBREAK%<sasmall><strong>Vectored Thrusters:</strong> Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BOOST% akciót.</sasmall>"""
        "Jan Ors":
           display_name: """Jan Ors"""
           text: """Amikor egy tűzíveden belüli baráti hajó elsődleges támadást hajt végre, ha nem vagy stresszes, kaphatsz 1 stressz jelzőt. Ha így teszel, az a hajó 1-gyel több támadókockával dobhat."""
        "Jek Porkins":
           display_name: """Jek Porkins"""
           text: """Miután kapsz egy stressz jelzőt, dobhatsz 1 támadó kockával, hogy levedd. %HIT% eredmény esetén elszenvedsz 1&nbsp;%HIT% sérülést."""
        "Joy Rekkoff":
           display_name: """Joy Rekkoff"""
           text: """Amikor támadást hajtasz végre, elkölthetsz 1&nbsp;%CHARGE% jelzőt egy felszerelt %TORPEDO% fejlesztésről. Ha így teszel a védekező 1-gyel kevesebb védekezőkockával dob.%LINEBREAK%<sasmall><strong>Concordia Faceoff:</strong> Amikor védekezel, ha a támadás 1-es távolságban történik és benne vagy a támadó %FRONTARC% tűzívében, megváltoztathatod 1 dobás eredményed %EVADE% eredményre.</sasmall>"""
        "Kaa'to Leeachos":
           display_name: """Kaa’to Leeachos"""
           text: """Az Ütközet fázis elején kiválaszthatsz egy 0-2-es távolságban lévő baráti hajót. Ha így teszel, áttehetsz róla 1 fókusz vagy kitérés jelzőt a magadra."""
        "Kad Solus":
           display_name: """Kad Solus"""
           text: """Miután teljesen végrehajtasz egy piros manővert, kapsz 2 fókusz jelzőt.%LINEBREAK%<sasmall><strong>Concordia Faceoff:</strong> Amikor védekezel, ha a támadás 1-es távolságban történik és benne vagy a támadó %FRONTARC% tűzívében, megváltoztathatod 1 dobás eredményed %EVADE% eredményre.</sasmall>"""
        "Kanan Jarrus":
           display_name: """Kanan Jarrus"""
           text: """Amikor egy tűzívedben lévő baráti hajó védekezik, elkölthetsz 1&nbsp;%FORCE% jelzőt. Ha így teszel, a támadó 1-gyel kevesebb támadókockával dob.%LINEBREAK%<strong>Tail Gun:</strong> ha van bedokkolt hajód, használhatod az elsődleges %REARARC% fegyvered, ugyanolyan támadási értékkel, mint a dokkolt hajó elsődleges %FRONTARC% támadási értéke."""
        "Kath Scarlet":
           display_name: """Kath Scarlet"""
           text: """Amikor támadást hajtasz végre, ha legalább 1 nem-limitált baráti hajó van 0-ás távolságra a védekezőtől, dobj 1-gyel több támadókockával."""
        "Kavil":
           display_name: """Kavil"""
           text: """Amikor egy nem-%FRONTARC% támadást hajtasz végre, dobj 1-gyel több támadókockával."""
        "Ketsu Onyo":
           display_name: """Ketsu Onyo"""
           text: """Az Ütközet fázis elején választhatsz 1 hajót ami a %FRONTARC% és %SINGLETURRETARC% tűzívedben is benne van 0-1-es távolságban. Ha így teszel, az a hajó kap egy vonósugár jelzőt."""
        "Koshka Frost":
           display_name: """Koshka Frost"""
           text: """Amikor védekezel vagy támadást hajtasz végre, ha az ellenséges hajó stresszes, újradobhatod 1 kockádat."""
        "Krassis Trelix":
           display_name: """Krassis Trelix"""
           text: """Végrehajthatsz egy %FRONTARC% speciális támadást a %REARARC% tűzívedből. Amikor speciális támadást hajtasz végre, újradobhatsz egy támadókockát."""
        "Kullbee Sperado":
           display_name: """Kullbee Sperado"""
           text: """Miután végrehajtasz egy %BARRELROLL% vagy %BOOST% akciót, megfordíthatod a felszerelt %CONFIG% fejlesztés kártyád."""
        "Kyle Katarn":
           display_name: """Kyle Katarn"""
           text: """Az Ütközet fázis elején átadhatod 1 fókusz jelződet egy tűzívedben lévő baráti hajónak."""
        "L3-37":
           display_name: """L3-37"""
           text: """Ha nincs pajzsod, csökkentsd a nehézségét a (%BANKLEFT% és %BANKRIGHT%) manővereknek."""
        "L3-37 (Escape Craft)":
           display_name: """L3-37"""
           text: """Ha nincs pajzsod, csökkentsd a nehézségét a (%BANKLEFT% és %BANKRIGHT%) manővereknek.%LINEBREAK%<strong>Co-Pilot:</strong> Amíg dokkolva vagy, az anyahajód megkapja a pilóta képességed, mintha a sajátja lenne."""
        "Laetin A'shera":
           display_name: """Laetin A’shera"""
           text: """Miután védekezel vagy támadást hajtasz végre, ha a támadás nem talált, kapsz 1 kitérés jelzőt.%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Lando Calrissian":
           display_name: """Lando Calrissian"""
           text: """Miután teljesen végrehajtasz egy kék manővert, választhatsz egy baráti hajót 0-3-as távolságban. Az a hajó végrehajthat egy akciót."""
        "Lando Calrissian (Scum)":
           display_name: """Lando Calrissian"""
           text: """Miután dobsz a kockákkal, ha nem vagy stresszes, kaphatsz 1 stressz jelzőt, hogy újradobhasd az összes üres eredményed."""
        "Lando Calrissian (Scum) (Escape Craft)":
           display_name: """Lando Calrissian"""
           text: """Miután dobsz a kockákkal, ha nem vagy stresszes, kaphatsz 1 stressz jelzőt, hogy újradobhasd az összes üres eredményed.%LINEBREAK%<strong>Co-Pilot:</strong> Amíg dokkolva vagy, az anyahajód megkapja a pilóta képességed, mintha a sajátja lenne."""
        "Latts Razzi":
           display_name: """Latts Razzi"""
           text: """Az Ütközet fázis elején kiválaszthatsz egy hajót 1-es távolságban és elköltheted a rajta lévő bemérés jelződet. Ha így teszel, az a hajó kap egy vonósugár jelzőt."""
        "Leevan Tenza":
           display_name: """Leevan Tenza"""
           text: """Miután végrehajtasz egy %BARRELROLL% vagy %BOOST% akciót, végrehajthatsz egy piros %EVADE% akciót."""
        "Lieutenant Blount":
           display_name: """Lieutenant Blount"""
           text: """Amikor elsődleges támadást hajtasz végre, ha legalább 1 másik baráti hajó van 0-1-es távolságban a védekezőtől, 1-gyel több támadókockával dobhatsz."""
        "Lieutenant Karsabi":
           display_name: """Lieutenant Karsabi"""
           text: """Miután kapsz egy inaktív fegyverzet jelzőt, ha nem vagy stresszes, kaphatsz 1 stressz jelzőt, hogy levegyél 1 inaktív fegyverzet jelzőt."""
        "Lieutenant Kestal":
           display_name: """Lieutenant Kestal"""
           text: """Amikor támadást hajtasz végre, miután a védekező dob a kockáival, elkölthetsz 1 fókusz jelzőt, hogy semlegesítsd a védekező összes üres és fókusz eredményét."""
        "Lieutenant Sai":
           display_name: """Lieutenant Sai"""
           text: """Miután végrehajtasz egy %COORDINATE% akciót, ha a koordinált hajó olyan akciót hajt végre, ami a te akciósávodon is rajta van, végrehajthatod azt az akciót."""
        "Lowhhrick":
           display_name: """Lowhhrick"""
           text: """Miután egy 0-1-es távolságban lévő baráti hajó védekezővé válik, elkölthetsz 1 erősítés jelzőt. Ha így teszel, az a hajó kap 1 kitérés jelzőt."""
        "Luke Skywalker":
           display_name: """Luke Skywalker"""
           text: """Miután védekező lettél (még a kockagurítás előtt), visszatölthetsz 1&nbsp;%FORCE% jelzőt."""
        "Maarek Stele":
           display_name: """Maarek Stele"""
           text: """Amikor támadást hajtasz végre, ha a védekező felfordított sérülés kártyát kapna, helyette húzz te 3 lapot, válassz egyet, a többit dobd el.%LINEBREAK%<sasmall><strong>Advanced Targeting Computer:</strong> Amikor végrehajtasz egy elsődleges támadást egy olyan védekező ellen, akit bemértél, 1-gyel több támadókockával dobj és változtasd 1&nbsp;%HIT% eredményed %CRIT% eredményre.</sasmall> """
        "Magva Yarro":
           display_name: """Magva Yarro"""
           text: """Amikor egy baráti hajó 0-2-es távolságban védekezik, a támadó maximum 1 kockáját dobhatja újra."""
        "Major Rhymer":
           display_name: """Major Rhymer"""
           text: """Amikor végrhajtasz egy %TORPEDO% vagy %MISSILE% támadást, növelheted vagy csökkentheted a fegyver távolság követelményét 1-gyel, a 0-3 korláton belül.%LINEBREAK%<strong>Nimble Bomber:</strong> Ha ledobnál egy eszközt a %STRAIGHT% sablon segítségével, használhatod az azonos sebességű %BANKLEFT% vagy %BANKRIGHT% sablonokat helyette."""
        "Major Vermeil":
           display_name: """Major Vermeil"""
           text: """Amikor támadást hajtasz végre, ha a védekezőnek nincs egy zöld jelzője sem, megváltoztathatod 1 üres vagy %FOCUS% eredményedet %HIT% eredményre.%LINEBREAK% %LINEBREAK%<sasmall><strong>Adaptive Ailerons:</strong> Mielőtt felfednéd a tárcsád, ha nem vagy stresszes, végre <b>kell</b> hajtanod egy fehér [1&nbsp;%BANKLEFT%), [1&nbsp;%STRAIGHT%] vagy [1&nbsp;%BANKRIGHT%] manővert.</sasmall>"""
        "Major Vynder":
           display_name: """Major Vynder"""
           text: """Amikor védekezel és van 'inaktív fegyverzet' jelződ, dobj 1-gyel több védekezőkockával."""
        "Manaroo":
           display_name: """Manaroo"""
           text: """Az Ütközet fázis elején kiválaszthatsz egy 0-1-es távolságban lévő baráti hajót. Ha így teszel, add át neki az összes zöld jelződ."""
        "Miranda Doni":
           display_name: """Miranda Doni"""
           text: """Amikor elsődleges támadást hajtasz végre, elkölthetsz 1 pajzsot, hogy 1-gyel több támadókockával dobj, vagy ha nincs pajzsod, dobhatsz 1-gyel kevesebb támadókockával, hogy visszatölts 1 pajzsot."""
        "Moralo Eval":
           display_name: """Moralo Eval"""
           text: """Ha lerepülsz a pályáról, elkölthetsz 1&nbsp;%CHARGE% jelzőt. Ha így teszel, helyezd a hajód tartalékba. A következő Tervezési fázis elején helyezd el a hajót a pálya szélétől 1-es távolságban azon az oldalon, ahol lerepültél."""
        "Norra Wexley (Y-Wing)":
           display_name: """Norra Wexley"""
           text: """Amikor védekezel, ha az ellenség 0-1-es távolságban van, adj 1&nbsp;%EVADE% eredményt a dobásodhoz."""
        "Norra Wexley":
           display_name: """Norra Wexley"""
           text: """Amikor védekezel, ha az ellenség 0-1-es távolságban van, adj 1&nbsp;%EVADE% eredményt a dobásodhoz."""
        "N'dru Suhlak":
           display_name: """N’dru Suhlak"""
           text: """Amikor elődleges támadást hajtasz végre, ha nincs baráti hajó 0-2 távolságban, dobj 1-gyel több támadókockával."""
        "Old Teroch":
           display_name: """Old Teroch"""
           text: """Az Ütközet fázis elején, kiválaszthatsz 1 ellenséges hajót 1-es távolságban. Ha így teszel és benne vagy a %FRONTARC% tűzívében, leveheted az összes zöld jelzőjét.%LINEBREAK%<sasmall><strong>Concordia Faceoff:</strong> Amikor védekezel, ha a támadás 1-es távolságban történik és benne vagy a támadó %FRONTARC% tűzívében, megváltoztathatod 1 dobás eredményed %EVADE% eredményre.</sasmall>"""
        "Outer Rim Pioneer":
           display_name: """Outer Rim Pioneer"""
           text: """Baráti hajók 0-1-es távolságban végrehajthatnak támadást akadálytól 0 távolságra.%LINEBREAK%<strong>Co-Pilot:</strong> Amíg dokkolva vagy, az anyahajód megkapja a pilóta képességed, mintha a sajátja lenne."""
        "Palob Godalhi":
           display_name: """Palob Godalhi"""
           text: """Az Ütközet fázis elején kiválaszthatsz 1 ellenséges hajót a tűzívedben 0-2 távolságban. Ha így teszel tedd át 1 fókusz vagy kitérés jelzőjét magadra."""
        "Prince Xizor":
           display_name: """Prince Xizor"""
           text: """Amikor védekezel, az <strong>Eredmények semlegesítése</strong> lépés után, egy 0-1 távolságban lévő másik baráti hajó, aki benne van a támadó tűzívében, elszenvedhet 1&nbsp;%HIT% vagy %CRIT% sérülést. Ha így tesz, hatástalaníts 1 ennek megfelelő eredményt.%LINEBREAK%<sasmall><strong>Microthrusters:</strong> Amikor orsózást hajtasz végre, a %BANKLEFT% vagy %BANKRIGHT% sablont <b>kell</b> használnod a %STRAIGHT% helyett.</sasmall>"""
        "Quinn Jast":
           display_name: """Quinn Jast"""
           text: """Az Ütközet fázis elején kaphatsz 1 'inaktív fegyverzet' jelzőt, hogy visszatölts 1&nbsp;%CHARGE% jelzőt egy felszerelt fejlesztésen.%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Rear Admiral Chiraneau":
           display_name: """Rear Admiral Chiraneau"""
           text: """Amikor támadást hajtasz végre, ha van 'reinforce' jelződ és a védekező a reinforce-nak megfelelő %FULLFRONTARC% vagy %FULLREARARC% tűzívedben van, megváltoztathatod 1&nbsp;%FOCUS% eredményed %CRIT% eredményre."""
        "Rexler Brath":
           display_name: """Rexler Brath"""
           text: """Miután végrehajtasz egy támadást, ami talál, ha van kitérés jelződ, fordítsd fel a védekező egy sérülés kártyáját.%LINEBREAK%<strong>Full Throttle:</strong> Miután teljesen végrehajtasz egy 3-5 sebességű manővert, végrehajthatsz egy %EVADE% akciót."""
        "Roark Garnet":
           display_name: """Roark Garnet"""
           text: """Az Ütközet fázis elején választhatsz 1 tűzívedben lévő hajót. Ha így teszel, a kezdeményezési értéke ebben a fázisban 7 lesz, függetlenül a nyomtatott értékétől."""
        "Sabine Wren":
           display_name: """Sabine Wren"""
           text: """Mielőtt aktiválódsz, végrehajthatsz egy %BARRELROLL% vagy %BOOST% akciót.%LINEBREAK%<sasmall><strong>Locked and Loaded:</strong> Amikor dokkolva vagy, miután az anyahajód végrehajtott egy elsődleges %FRONTARC% vagy %TURRET% támadást, végrehajthat egy bónusz %REARARC% támadást.</sasmall>"""
        "Sabine Wren (TIE Fighter)":
           display_name: """Sabine Wren"""
           text: """Mielőtt aktiválódsz, végrehajthatsz egy %BARRELROLL% vagy %BOOST% akciót."""
        "Sabine Wren (Scum)":
           display_name: """Sabine Wren"""
           text: """Amikor védekezel, ha a támadó benne van a %SINGLETURRETARC% tűzívedben 0-2-es távolságban, hozzáadhatsz 1&nbsp;%FOCUS% eredményt a dobásodhoz."""
        "Sarco Plank":
           display_name: """Sarco Plank"""
           text: """Amikor védekezel kezelheted a mozgékonyság értékedet úgy, hogy az megegyezzen az ebben a körben végrehajtott manővered sebességével.%LINEBREAK%<strong>Spacetug Tractor Array:</strong> <strong>Akció:</strong>: Válassz egy hajót a %FRONTARC% tűzívedben 1-es távolságban. Az a hajó kap 1 vonósugár jelzőt vagy 2 vonósugár jelzőt, ha benne van a %BULLSEYEARC% tűzívedben 1-es távolságban."""
        "Saw Gerrera":
           display_name: """Saw Gerrera"""
           text: """Amikor egy sérült baráti hajó 0-3-as távolságban végrehajt egy támadást, újradobhat 1 támadókockát."""
        "Serissu":
           display_name: """Serissu"""
           text: """Amikor egy baráti hajó 0-1-es távolságban védekezik, újradobhatja 1 kockáját.%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Seventh Sister":
           display_name: """Seventh Sister"""
           text: """Amikor végrehajtasz egy elsődleges támadást, az <strong>Eredmények semlegesítése</strong> lépés előtt elkölthetsz 2 %FORCE% jelzőt, hogy hatástalaníts 1&nbsp;%EVADE% eredményt."""
        "Seyn Marana":
           display_name: """Seyn Marana"""
           text: """Amikor végrehajtasz egy támadást elkölthetsz 1&nbsp;%CRIT% eredményt. Ha így teszel, a védekező kap 1 lefordított sérülés kártyát, majd hatástalanítsd a többi dobás eredményed."""
        "Shara Bey":
           display_name: """Shara Bey"""
           text: """Amikor védekezel vagy elsődleges támadást hajtasz végre, elköltheted az ellenfeledre tett bemérés jelződet, hogy hozzáadj 1&nbsp;%FOCUS% eredményt dobásodhoz."""
        "Sol Sixxa":
           display_name: """Sol Sixxa"""
           text: """Ha ledobnál egy eszközt az [1&nbsp;%STRAIGHT%] sablon használatával, helyette ledobhatod más 1-es sebességű sablonnal."""
        "Soontir Fel":
           display_name: """Soontir Fel"""
           text: """Az Ütközet fázis elején, ha van ellenséges hajó a %BULLSEYEARC% tűzívedben, kapsz 1 fókusz jelzőt.%LINEBREAK%<strong>Autothrusters:</strong> Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BARRELROLL% vagy piros %BOOST% akciót."""
        "Sunny Bounder":
           display_name: """Sunny Bounder"""
           text: """Amikor védekezel vagy támadást hajtasz végre, miután dobtál vagy újradobtál kockákat, ha minden eredményed egyforma, hozzáadhatsz 1 ugyanolyan eredményt a dobáshoz.%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Talonbane Cobra":
           display_name: """Talonbane Cobra"""
           text: """Amikor 3-as távolságban védekezel vagy 1-es távolságban támadást hajtasz végre, dobj 1-gyel több kockával."""
        "Tel Trevura":
           display_name: """Tel Trevura"""
           text: """Ha megsemmisülnél, elkölthetsz 1&nbsp;%CHARGE% jelzőt. Ha így teszel, dobd el az összes sérülés kártyádat, szenvedj el 5&nbsp;%HIT% sérülést, majd helyezd magad tartalékba. A következő Tervezési fázis elején helyezd fel a hajód 1-es távolságban a saját oldaladon."""
        "Ten Numb":
           display_name: """Ten Numb"""
           text: """Amikor védekezel vagy támadást hajtasz végre, elkölthetsz 1 stressz jelzőt, hogy minden %FOCUS% eredményed megváltoztasd %EVADE% vagy %HIT% eredményre."""
        "Thane Kyrell":
           display_name: """Thane Kyrell"""
           text: """Amikor támadást hajtasz végre, elkölthetsz 1&nbsp;%FOCUS%, %HIT% vagy %CRIT% eredményt, hogy megnézd a védekező képpel lefelé fordított sérülés kártyáit, kiválassz egyet és megfordítsd."""
        "Tomax Bren":
           display_name: """Tomax Bren"""
           text: """Miután végrehajtasz egy %RELOAD% akciót, visszatölthetsz 1&nbsp;%CHARGE% jelzőt 1 felszerelt %TALENT% fejlesztés kártyán.%LINEBREAK%<strong>Nimble Bomber:</strong> Ha ledobnál egy eszközt a %STRAIGHT% sablon segítségével, használhatod az azonos sebességű %BANKLEFT% vagy %BANKRIGHT% sablonokat helyette."""
        "Torani Kulda":
           display_name: """Torani Kulda"""
           text: """Miután végrehajtasz egy támadást, minden ellenséges hajó a %BULLSEYEARC% tűzívedben elszenved 1&nbsp;%HIT% sérülést, hacsak el nem dob 1 zöld jelzőt.%LINEBREAK%<sasmall><strong>Dead to Rights:</strong> Amikor végrehajtasz egy támadást, ha a védekező benne van a %BULLSEYEARC% tűzívedben, a védekezőkockák nem módosíthatók zöld jelzőkkel.</sasmall>"""
        "Torkil Mux":
           display_name: """Torkil Mux"""
           text: """Az Ütközet fázis elején kiválaszthatsz 1 hajót a tűzívedben. Ha így teszel, az a hajó ebben a körben 0-ás kezdeményezéssel kerül sorra a normál kezdeményezése helyett."""
        "Turr Phennir":
           display_name: """Turr Phennir"""
           text: """Miután végrehajtasz egy támadást, végrehajthatsz egy %BARRELROLL% vagy %BOOST% akciót akkor is ha stresszes vagy.%LINEBREAK%<strong>Autothrusters:</strong> Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BARRELROLL% vagy piros %BOOST% akciót."""
        "Unkar Plutt":
           display_name: """Unkar Plutt"""
           text: """Az Ütközet fázis elején, ha van egy vagy több másik hajó 0-ás távolságban tőled, te és a 0-ás távolságra lévő hajók kapnak egy vonósugár jelzőt.%LINEBREAK%<strong>Spacetug Tractor Array:</strong> <strong>Akció:</strong>: Válassz egy hajót a %FRONTARC% tűzívedben 1-es távolságban. Az a hajó kap 1 vonósugár jelzőt vagy 2 vonósugár jelzőt, ha benne van a %BULLSEYEARC% tűzívedben 1-es távolságban."""
        "Valen Rudor":
           display_name: """Valen Rudor"""
           text: """Miután egy baráti hajó 0-1-es távolságban védekezik - a sérülések elkönyvelése után, ha volt -, végrehajthatsz egy akciót."""
        "Ved Foslo":
           display_name: """Ved Foslo"""
           text: """Amikor végrehajtasz egy manővert, helyette végrehajthatsz egy manővert ugyanabban az irányban és nehézségben 1-gyel kisebb vagy nagyobb sebességgel.%LINEBREAK%<sasmall><strong>Advanced Targeting Computer:</strong> Amikor végrehajtasz egy elsődleges támadást egy olyan védekező ellen, akit bemértél, 1-gyel több támadókockával dobj és változtasd 1&nbsp;%HIT% eredményed %CRIT% eredményre.</sasmall>"""
        "Viktor Hel":
           display_name: """Viktor Hel"""
           text: """Miután védekeztél, ha nem pontosan 2 védekezőkockával dobtál, a támadó kap 1 stress jelzőt."""
        "Wedge Antilles":
           display_name: """Wedge Antilles"""
           text: """Amikor támadást hajtasz végre, a védekező 1-gyel kevesebb védekezőkockával dob."""
        "Wullffwarro":
           display_name: """Wullffwarro"""
           text: """Amikor elsődleges támadást hajtasz végre, ha sérült vagy, 1-gyel több támadókockával dobhatsz."""
        "Zertik Strom":
           display_name: """Zertik Strom"""
           text: """A Vége fázis alatt elköltheted egy ellenséges hajón lévő bemérődet hogy felfordítsd egy sérülés kártyáját.%LINEBREAK%<sasmall><strong>Advanced Targeting Computer:</strong> Amikor végrehajtasz egy elsődleges támadást egy olyan védekező ellen, akit bemértél, 1-gyel több támadókockával dobj és változtasd 1&nbsp;%HIT% eredményed %CRIT% eredményre.</sasmall>"""
        "Zuckuss":
           display_name: """Zuckuss"""
           text: """Amikor végrehajtasz egy elsődleges támadást, 1-gyel több támadókockával dobhatsz. Ha így teszel, a védekező 1-gyel több védekezőkockával dob."""
        '"Chopper"':
           display_name: """“Chopper”"""
           text: """Az Ütközet fázis elején minden 0-ás távolságban lévő ellenséges hajó 2 zavarás jelzőt kap.%LINEBREAK%<strong>Tail Gun:</strong> ha van bedokkolt hajód, használhatod az elsődleges %REARARC% fegyvered, ugyanolyan támadási értékkel, mint a dokkolt hajó elsődleges %FRONTARC% támadási értéke."""
        '"Countdown"':
           display_name: """“Countdown”"""
           text: """Amikor védekezel, az <strong>Eredmények semlegesítése</strong> lépés után, ha nem vagy stresszes, választhatod, hogy elszenvedsz 1&nbsp;%HIT% sérülést és kapsz 1 stressz jelzőt. Ha így teszel, vess el minden kocka dobást.%LINEBREAK%<sasmall><strong>Adaptive Ailerons:</strong> Mielőtt felfednéd a tárcsád, ha nem vagy stresszes, végre <b>kell</b> hajtanod egy fehér [1&nbsp;%BANKLEFT%), [1&nbsp;%STRAIGHT%] vagy [1&nbsp;%BANKRIGHT%] manővert.</sasmall>"""
        '"Deathfire"':
           display_name: """“Deathfire”"""
           text: """Miután megsemmisülsz, mielőtt levennéd a hajód, végrehajthatsz egy támadást és ledobhatsz vagy kilőhetsz 1 eszközt.%LINEBREAK%<strong>Nimble Bomber:</strong> Ha ledobnál egy eszközt a %STRAIGHT% sablon segítségével, használhatod az azonos sebességű %BANKLEFT% vagy %BANKRIGHT% sablonokat helyette."""
        '"Deathrain"':
           display_name: """“Deathrain”"""
           text: """Miután ledobsz vagy kilősz egy eszközt, végrehajthatsz egy akciót."""
        '"Double Edge"':
           display_name: """“Double Edge”"""
           text: """Miután végrehajtasz egy %TURRET% vagy %MISSILE% támadást ami nem talál, végrehajthatsz egy bónusz támadást egy másik fegyverrel."""
        '"Duchess"':
           display_name: """“Duchess”"""
           text: """Választhatsz úgy, hogy nem használod az <strong>Adaptive Ailerons</strong> képességed. Használhatod akkor is <strong>Adaptive Ailerons</strong> képességed, amikor stresszes vagy.%LINEBREAK%<sasmall><strong>Adaptive Ailerons:</strong> Mielőtt felfednéd a tárcsád, ha nem vagy stresszes, végre <b>kell</b> hajtanod egy fehér [1&nbsp;%BANKLEFT%), [1&nbsp;%STRAIGHT%] vagy [1&nbsp;%BANKRIGHT%] manővert.</sasmall>"""
        '"Dutch" Vander':
           display_name: """“Dutch” Vander"""
           text: """Miután %LOCK% akciót hajtottál végre választhatsz 1 baráti hajót 1-3-as távolságban. Az a hajó is bemérheti az általad bemért objektumot, függetlenül a távolságtól."""
        '"Echo"':
           display_name: """“Echo”"""
           text: """Amikor kijössz az álcázásból, a [2&nbsp;%BANKLEFT%] vagy [2&nbsp;%BANKRIGHT%] sablont <b>kell</b> használnod a [2&nbsp;%STRAIGHT%] helyett.%LINEBREAK%<strong>Stygium Array:</strong> Miután kijössz az álcázásból végrehajthatsz egy %EVADE% akciót. A Vége fázis elején elkölthetsz 1 kitérés jelzőt, hogy kapj egy álcázás jelzőt."""
        '"Howlrunner"':
           display_name: """“Howlrunner”"""
           text: """Amikor egy 0-1-es távolságban lévő baráti hajó elsődleges támadást hajt végre, 1 támadókockát újradobhat."""
        '"Leebo"':
           display_name: """“Leebo”"""
           text: """Miután védekeztél vagy támadást hajtottál végre, ha elköltöttél egy kalkuláció jelzőt, kapsz 1 kalkuláció jelzőt.%LINEBREAK%<strong>Sensor Blindspot:</strong> Amikor elsődleges támadást hajtasz végre 0-1-es távolságban, nem érvényesül a 0-1-es távolságért járó bónusz és 1-gyel kevesebb támadókockával dobsz."""
        '"Mauler" Mithel':
           display_name: """“Mauler” Mithel"""
           text: """Amikor támadást hajtasz végre 1-es távolságban, dobj 1-gyel több támadókockával."""
        '"Night Beast"':
           display_name: """“Night Beast”"""
           text: """Miután teljesen végrehajtasz egy kék manővert, végrehajthatsz egy %FOCUS% akciót."""
        '"Pure Sabacc"':
           display_name: """“Pure Sabacc”"""
           text: """Amikor támadást hajtasz végre, ha 1 vagy kevesebb sérüléskártyád van, 1-gyel több támadókockával dobhatsz.%LINEBREAK%<sasmall><strong>Adaptive Ailerons:</strong> Mielőtt felfednéd a tárcsád, ha nem vagy stresszes, végre <b>kell</b> hajtanod egy fehér [1&nbsp;%BANKLEFT%), [1&nbsp;%STRAIGHT%] vagy [1&nbsp;%BANKRIGHT%] manővert.</sasmall>"""
        '"Redline"':
           display_name: """“Redline”"""
           text: """Fenntarthatsz 2 bemérő jelzőt. Miután végrehajtasz egy akciót, feltehetsz egy bemérő jelzőt."""
        '"Scourge" Skutu':
           display_name: """“Scourge” Skutu"""
           text: """Amikor végrehajtasz egy támadást a %BULLSEYEARC% tűzívedben lévő védekező ellen, dobj 1-gyel több támadókockával."""
        '"Vizier"':
           display_name: """“Vizier”"""
           text: """Miután teljesen végrehajtasz egy 1-es sebességű manővert az <strong>Adaptive Ailerons</strong> képességed használatával, végrehajthatsz egy %COORDINATE% akciót. Ha így teszel, hagyd ki az <strong>Akció végrehajtása</strong> lépést.%LINEBREAK%<sasmall><strong>Adaptive Ailerons:</strong> Mielőtt felfednéd a tárcsád, ha nem vagy stresszes, végre <b>kell</b> hajtanod egy fehér [1&nbsp;%BANKLEFT%), [1&nbsp;%STRAIGHT%] vagy [1&nbsp;%BANKRIGHT%] manővert.</sasmall>"""
        '"Wampa"':
           display_name: """“Wampa”"""
           text: """Amikor végrehajtasz egy támadást, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy 1-gyel több támadókockával dobj. Védekezés után elvesztesz 1&nbsp;%CHARGE% jelzőt."""
        '"Whisper"':
           display_name: """“Whisper”"""
           text: """Miután végrehajtasz egy támadást ami talál, kapsz 1 kitérés jelzőt.%LINEBREAK%<strong>Stygium Array:</strong> Miután kijössz az álcázásból végrehajthatsz egy %EVADE% akciót. A Vége fázis elején elkölthetsz 1 kitérés jelzőt, hogy kapj egy álcázás jelzőt."""
        '"Zeb" Orrelios':
           display_name: """“Zeb” Orrelios"""
           text: """Amikor védekezel a %CRIT% találatok előbb semlegesítődnek a %HIT% találatoknál.%LINEBREAK%<sasmall><strong>Locked and Loaded:</strong> Amikor dokkolva vagy, miután az anyahajód végrehajtott egy elsődleges %FRONTARC% vagy %TURRET% támadást, végrehajthat egy bónusz %REARARC% támadást.</sasmall>"""
        '"Zeb" Orrelios (Sheathipede)':
           display_name: """“Zeb” Orrelios"""
           text: """Amikor védekezel a %CRIT% találatok előbb semlegesítődnek a %HIT% találatoknál.%LINEBREAK%<sasmall><strong>Comms Shuttle:</strong> Amikor dokkolva vagy az anyahajód %COORDINATE% akció lehetőséget kap. Az anyahajód aktiválása előtt végrehajthat egy %COORDINATE% akciót.</sasmall>"""
        '"Zeb" Orrelios (TIE Fighter)':
           display_name: """“Zeb” Orrelios"""
           text: """Amikor védekezel a %CRIT% találatok előbb semlegesítődnek a %HIT% találatoknál."""
        "Poe Dameron":
           text: """Miután végrehajtasz egy akciót, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy végrehajts egy fehér akciót pirosként kezelve.%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Lieutenant Bastian":
           text: """Miután egy hajó 1-2-es távolságban felhúz egy sérülés kártyát, felrakhatsz rá egy bemérő jelzőt.%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        '"Midnight"':
           text: """Amikor védekezel vagy támadás hajtasz végre, ha van bemérőd azon az ellenséges hajón, az nem módosíthatja a kockáit."""
        '"Longshot"':
           text: """Amikor elsődleges támadást hajtasz végre 3-as távolságban, dobj 1-gyel több támadókockával."""
        '"Muse"':
           text: """Az Ütközet fázis elején válaszhatsz egy baráti hajót 0-1-es távolságban. Ha így teszel, az a hajó vegyen le 1 stressz jelzőt."""
        "Kylo Ren":
           text: """Miután védekeztél, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy hozzárendeled az <strong>I'll Show You the Dark Side</strong> kondíciós kártyát a támadódhoz.%LINEBREAK%<strong>Autothrusters:</strong> Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BARRELROLL% vagy piros %BOOST% akciót."""
        '"Blackout"':
           text: """Amikor végrehajtasz egy támadást, ha a támadás akadályozott egy akadály által, a védekező 2-vel kevesebb védekezőkockával dob.%LINEBREAK%<strong>Autothrusters:</strong> Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BARRELROLL% vagy piros %BOOST% akciót."""
        "Lieutenant Dormitz":
           text: """Felhelyezés: Miután  felhelyezésre kerültél, a többi baráti hajó bárhova helyezhető a játékterületen tőled 0-2-es távolságban.%LINEBREAK%<strong>Linked battery:</strong> Amikor végrehajtasz egy %CANNON% támadást, dobj 1-gyel több támadókockával."""
        '"Backdraft"':
           text: """Amikor végrehajtasz egy %SINGLETURRETARC% elsődleges támadást, ha a védekező benne van a %REARARC% tűzívedben dobj 1-gyel több kockával.%LINEBREAK%<strong>Heavy Weapon Turret:</strong> A %SINGLETURRETARC% mutatódat csak %FRONTARC% vagy %REARARC% irányba forgathatod. A felszerelt %MISSILE% fejlesztésed %FRONTARC% követelményét kezeld úgy mintha %SINGLETURRETARC% lenne."""
        '"Quickdraw"':
           text: """Miután elvesztesz egy pajzsot, elkölthetsz 1&nbsp;%CHARGE% jelzőt. Ha így teszel, végrehajthatsz egy bónusz elsődleges támadást.%LINEBREAK%<strong>Heavy Weapon Turret:</strong> A %SINGLETURRETARC% mutatódat csak %FRONTARC% vagy %REARARC% irányba forgathatod. A felszerelt %MISSILE% fejlesztésed %FRONTARC% követelményét kezeld úgy mintha %SINGLETURRETARC% lenne."""
        "Zeta Squadron Survivor":
           text: """<strong>Heavy Weapon Turret:</strong> A %SINGLETURRETARC% mutatódat csak %FRONTARC% vagy %REARARC% irányba forgathatod. A felszerelt %MISSILE% fejlesztésed %FRONTARC% követelményét kezeld úgy mintha %SINGLETURRETARC% lenne."""
        "Rey":
           text: """Amikor védekezel vagy támadást hajtasz végre, ha az ellenséges hajó benne van a %FRONTARC% tűzívedben, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy 1 üres eredményed %EVADE% vagy %HIT% eredményre változtasd."""
        "Han Solo (Resistance)":
           text: """Felhelyezés: Bárhova felhelyezheted a hajód a játékterületre 3-as távolságon túl az ellenséges hajóktól."""
        "Chewbacca (Resistance)":
           text: """Miután egy baráti hajó 0-3-as távolságban megsemmisül, végrehajthatsz egy akciót. Aztán végrehajthatsz egy bónusz támadást."""
        "Captain Seevor":
           text: """Amikor védekezel vagy támadást hajtasz végre, mielőtt a támadókockát elgurulnának, ha nem vagy az ellenséges hajó %BULLSEYEARC% tűzívében, elkölthetsz 1&nbsp;%CHARGE% jelzőt. Ha így teszel, az ellenséges hajó kap egy zavarás jelzőt.%LINEBREAK%<strong>Notched Stabilizers:</strong> Amikor mozogsz, hagyd figyelmen kívül az aszteroidákat."""
        "Mining Guild Surveyor":
           text: """<strong>Notched Stabilizers:</strong> Amikor mozogsz, hagyd figyelmen kívül az aszteroidákat."""
        "Mining Guild Sentry":
           text: """<strong>Notched Stabilizers:</strong> Amikor mozogsz, hagyd figyelmen kívül az aszteroidákat."""
        "Ahhav":
           text: """Amikor védekezel vagy támadást hajtasz végre, ha az elleséges hajó nagyobb talpméretű, dobj 1-gyel több kockával.%LINEBREAK%<strong>Notched Stabilizers:</strong> Amikor mozogsz, hagyd figyelmen kívül az aszteroidákat."""
        "Finch Dallow":
           text: """Mielőtt ledobnál egy bombát, ledobás helyett elhelyezheted a játékterületen úgy, hogy érintkezzen veled."""
        "Major Stridan":
           text: """Amikor koordinálsz vagy egy fejlesztés kártyád hatását alkalmaznád, kezelheted úgy a 2-3-as távolságban lévő baráti hajókat, mintha 0 vagy 1-es távolságban lennének.%LINEBREAK%<strong>Linked battery:</strong> Amikor végrehajtasz egy %CANNON% támadást, dobj 1-gyel több támadókockával."""
        "Kare Kun":
           text: """Amikor gyorsítasz (%BOOST%), használhatod a [1&nbsp;%TURNLEFT%] vagy [1&nbsp;%TURNRIGHT%] sablonokat is.%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Joph Seastriker":
           text: """Miután elvesztesz 1 pajzsod, kapsz 1&nbsp;%EVADE% jelzőt.%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Lieutenant Bastian":
           text: """Miután egy hajó 1-2-es távolságban felhúz egy sérülés kártyát, felrakhatsz rá egy bemérő jelzőt.%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Jaycris Tubbs":
           text: """Miután teljesen végrehajtasz egy kék manővert, választhatsz egy baráti hajót 0-1-es távolságban. Ha így teszel, az a hajó levesz egy stressz jelzőt.%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Black Squadron Ace (T-70)":
           text: """<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Red Squadron Expert":
           text: """<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Blue Squadron Rookie":
           text: """<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Cobalt Squadron Bomber":
           text: """ """
        "TN-3465":
           text: """Amikor egy másik baráti hajó támadást hajt végre, ha 0-1 távolságban vagy a védekezőtől, elszenvedhetsz 1&nbsp;%CRIT% sérülést, hogy a támadó 1 eredményét %CRIT% eredményre változtassa."""
        '"Scorch"':
           text: """Amikor elsődleges támadást hajtasz végre, ha nem vagy stresszes, kaphatsz 1 stressz jelzőt, hogy 1-gyel több támadókockával dobj."""
        '"Longshot"':
           text: """Amikor elsődleges támadást hajtasz végre 3-as távolságban, dobj 1-gyel több támadókockával."""
        '"Static"':
           text: """Amikor elsődleges támadást hajtasz végre, elköltheted a védekezőn lévő bemérődet és egy %FOCUS% jelződ, hogy minden eredményed %CRIT% eredményre változtass."""
        "Lieutenant Rivas":
           text: """Miután egy hajó 1-2-es távolságban kap egy piros vagy narancs jelzőt, ha nem volt bemérőd a hajón, feltehetsz egyet rá."""
        "Commander Malarus":
           text: """Az Ütközet fázis elején elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy kapj 1 stressz jelzőt. Ha így teszel, a kör végéig ha védekezel vagy támadást hajtasz végre, megváltoztathatsz minden %FOCUS% eredményed %EVADE% vagy %HIT% eredményre."""
        "Omega Squadron Ace":
           text: """"""
        "Zeta Squadron Pilot":
           text: """"""
        "Epsilon Squadron Cadet":
           text: """"""
        "Greer Sonnel":
           text: """Miután teljesen végrehajtasz egy manővert, forgathatod a %SINGLETURRETARC% tűzívedet.%SINGLETURRETARC% %LINEBREAK%<strong>Refined Gyrostabilizers:</strong> A %SINGLETURRETARC% mutatódat csak %FRONTARC% vagy %REARARC% irányba forgathatod. Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BOOST% vagy %ROTATEARC% akciót."""
        "L'ulo L'ampar":
           text: """Amikor védekezel vagy elsődleges támadást hajtasz végre, ha stresszes vagy, 1-gyel kevesebb védekezőkockával vagy 1-gyel több támadókockával <strong>kell</strong> dobnod.%LINEBREAK%<strong>Refined Gyrostabilizers:</strong> A %SINGLETURRETARC% mutatódat csak %FRONTARC% vagy %REARARC% irányba forgathatod. Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BOOST% vagy %ROTATEARC% akciót."""
        "Zari Bangel":
           text: """Ne hagyd ki az <strong>Akció végrehajtása</strong> lépést, miután részlegesen hajtottál végre egy manővert.%LINEBREAK%<strong>Refined Gyrostabilizers:</strong> A %SINGLETURRETARC% mutatódat csak %FRONTARC% vagy %REARARC% irányba forgathatod. Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BOOST% vagy %ROTATEARC% akciót."""
        "Tallissan Lintra":
           text: """Amikor egy ellenséges hajó a %BULLSEYEARC% tűzívedben végrehajt egy támadást, elkölthetsz 1&nbsp;%CHARGE% jelzőt. Ha így teszel, a védekező 1-gyel több kockával dob.%LINEBREAK%<strong>Refined Gyrostabilizers:</strong> A %SINGLETURRETARC% mutatódat csak %FRONTARC% vagy %REARARC% irányba forgathatod. Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BOOST% vagy %ROTATEARC% akciót."""
        "Darth Maul":
           text: """Miután végrehajtasz egy támadást, elkölthetsz 2 %FORCE% jelzőt, hogy végrehajts egy bónusz elsődleges támadást egy másik célpont ellen. Ha az első támadás nem talált, a bónusz támadást végrehajthatod ugyanazon célpont ellen."""
        '"Sinker"':
           text: """Amikor 1-2-es távolságban és a %LEFTARC% vagy %RIGHTARC% tűzívedben lévő baráti hajó végrehajt egy elsődleges támadást, újradobhat 1 támadókockát."""
        "Petty Officer Thanisson":
           text: """Az Aktivációs vagy Ütközet fázis közben, miután egy hajó a %FRONTARC% tűzívedben 1-2-es távolságban kap 1 stressz jelzőt, elkölthetsz 1&nbsp;%CHARGE% jelzőt. Ha így teszel, az a hajó kap egy vonósugár jelzőt.%LINEBREAK%<strong>Linked battery:</strong> Amikor végrehajtasz egy %CANNON% támadást, dobj 1-gyel több támadókockával."""
        "Captain Cardinal":
           text: """Amikor egy baráti hajó 1-2-es távolságban, a tiédnél alacsonyabb kezdeményezéssel védekezik vagy támadást hajt végre, ha van legalább 1&nbsp;%CHARGE% jelződ, az a hajó újradobhat 1&nbsp;%FOCUS% eredményét. Miután egy ellenséges hajó 0-3-as távolságban megsemmisül, elvesztesz 1&nbsp;%CHARGE% jelzőt.%LINEBREAK%<strong>Linked battery:</strong> Amikor végrehajtasz egy %CANNON% támadást, dobj 1-gyel több támadókockával."""
        '"Avenger"':
           text: """Miután egy ellenséges hajó 0-3-as távolságban megsemmisül végrehajthatsz egy akciót, akkor is ha stresszes vagy. %LINEBREAK%<strong>Autothrusters:</strong> Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BARRELROLL% vagy piros %BOOST% akciót."""
        '"Recoil"':
           text: """Amikor stresszes vagy kezelheted úgy a %FRONTARC% tűzívedben 0-1-es távolságban lévő ellenséges hajókat, mintha a %BULLSEYEARC% tűzívedben lennének.%LINEBREAK%<strong>Autothrusters:</strong> Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BARRELROLL% vagy piros %BOOST% akciót."""
        "Omega Squadron Expert":
           text: """<strong>Heavy Weapon Turret:</strong> A %SINGLETURRETARC% mutatódat csak %FRONTARC% vagy %REARARC% irányba forgathatod. A felszerelt %MISSILE% fejlesztésed %FRONTARC% követelményét kezeld úgy mintha %SINGLETURRETARC% lenne."""
        "Sienar-Jaemus Engineer":
           text: """<strong>Autothrusters:</strong> Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BARRELROLL% vagy piros %BOOST% akciót."""
        "First Order Test Pilot":
           text: """<strong>Autothrusters:</strong> Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BARRELROLL% vagy piros %BOOST% akciót."""
        "Starkiller Base Pilot":
           text: """<strong>Linked battery:</strong> Amikor végrehajtasz egy %CANNON% támadást, dobj 1-gyel több támadókockával."""
        "Lieutenant Tavson":
           text: """Miután sérülést szenvedsz el, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy végrehajts egy akciót.%LINEBREAK%<strong>Linked battery:</strong> Amikor végrehajtasz egy %CANNON% támadást, dobj 1-gyel több támadókockával."""
        '"Null"':
           text: """Amíg nem vagy sérült, kezeld a kezdeményezési értéked 7-esként."""
        "Cat":
           text: """Amikor elsődleges támadást hajtasz végre, ha a védekező 0-1-es távolságban van legalább 1 baráti eszköztől, dobj 1-gyel több kockával."""
        "Ben Teene":
           text: """Miután végrehajtasz egy támadást, ha a védekező benne van a %SINGLETURRETARC% tűzívedben, rendeld hozzá a <strong>Rattled</strong> kondíciós kártyát a védekezőhöz."""
        "Vennie":
           text: """Amikor védkezel, ha a támadó benne van egy baráti hajó %SINGLETURRETARC% tűzívében, hozzáadhatsz 1&nbsp;%FOCUS% eredményt a dobásodhoz."""
        "Edon Kappehl":
           text: """Miután teljesen végrehajtasz egy kék vagy fehér manővert, ha még nem dobtál vagy lőttél ki eszközt ebben a körben, kidobhatsz egy eszközt."""
        "Resistance Sympathizer":
           text: """"""
        "Jessika Pava":
           text: """Amikor védekezel vagy támadást hajtasz végre, elkölthetsz 1&nbsp;%CHARGE% jelzőt vagy a felszerelt %ASTROMECH% fejlesztéseden lévő 1 nem visszatölthető %CHARGE% jelzőt, hogy újradobj 1 kockát minden 0-1-es távolságban lévő baráti hajó után.%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Temmin Wexley":
           text: """Miután teljesen végrehajtasz egy 2-4 sebességű manővert, végrehajthatsz egy %BOOST% akciót%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Nien Nunb":
           text: """Miután kapsz egy stressz jelzőt, ha van ellenséges hajó a %FRONTARC% tűzívedben 0-1 távolságban, leveheted a kapott stressz jelzőt.%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Ello Asty":
           text: """Miután felfedtél egy piros Tallon Roll (%TROLLLEFT% vagy %TROLLRIGHT%) manővert, ha 2 vagy kevesebb stressz jelződ van, kezeld a manővert fehérként.%LINEBREAK%<strong>Weapon Hardpoint:</strong> Felszerelhetsz 1&nbsp;%CANNON%, %TORPEDO% vagy %MISSILE% fejlesztést."""
        "Blue Squadron Recruit":
           text: """<strong>Refined Gyrostabilizers:</strong> A %SINGLETURRETARC% mutatódat csak %FRONTARC% vagy %REARARC% irányba forgathatod. Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BOOST% vagy %ROTATEARC% akciót."""
        "Green Squadron Expert":
           text: """<strong>Refined Gyrostabilizers:</strong> A %SINGLETURRETARC% mutatódat csak %FRONTARC% vagy %REARARC% irányba forgathatod. Miután végrehajtasz egy akciót, végrehajthatsz egy piros %BOOST% vagy %ROTATEARC% akciót."""
        "Foreman Proach":
           text: """Mielőtt sorra kerülsz az Ütközet fázisban, választhasz 1 ellenséges hajót a %BULLSEYEARC% tűzívedben 1-2-es távolságban és kapsz 1 'inaktív fegyverzet' jelzőt. Ha így teszel, az a hajó kap 1 vonósugár jelzőt.%LINEBREAK%<strong>Notched Stabilizers:</strong> Amikor mozogsz, hagyd figyelmen kívül az aszteroidákat."""
        "Overseer Yushyn":
           text: """Mielőtt egy baráti hajó 1-es távolságban kapna 1 'inaktív fegyverzet' jelzőt, ha az a hajó nem stresszes, elkölthetsz 1&nbsp;%CHARGE% jelzőt. Ha így teszel, az a hajó 1 stressz jelzőt kap helyette.%LINEBREAK%<strong>Notched Stabilizers:</strong> Amikor mozogsz, hagyd figyelmen kívül az aszteroidákat."""
        "General Grievous":
           text: """Amikor elsődleges támadást hajtasz végre, ha nem vagy a védekező tűzívében, újradobhatod akár 2 támadókockádat is."""
        "Wat Tambor":
           text: """Amikor elsődleges támadást hajtasz végre, újradobhatsz 1 támadókockát minden kalkuláció tokennel rendelkező baráti hajó után ami a védekezőtől 1-es távolságban van."""
        "Captain Sear":
           text: """Amikor egy baráti hajó 0-3-as távolságban végrehajt egy elsődleges támadást, ha a védekező benne van annak %BULLSEYEARC% tűzívében, az 'Eredmények semlegesítése' lépés előtt a baráti hajó elkölthet 1&nbsp;%CALCULATE% jelzőt, hogy semlegesítsen 1&nbsp;%EVADE% eredményt."""
        "Precise Hunter":
           text: """Amikor támadást hajtasz végre, ha a védekező benne van a %BULLSEYEARC% tűzívedben, újradobhatsz 1 üres eredményt.%LINEBREAK% NETWORKED CALCULATIONS: Amikor védekezel vagy támadást hajtasz végre, elkölthetsz 1&nbsp;%CALCULATE% jelzőt egy 0-1-es távolságban lévő baráti hajóról, hogy megváltoztass 1&nbsp;%FOCUS% eredményt %EVADE% vagy %HIT% eredményre."""
        "Haor Chall Prototype":
           text: """Miután egy ellenséges hajó a %BULLSEYEARC% tűzívedben 0-2-es távolságban védekezőnek jelöl egy másik baráti hajót, végrehajthatsz egy %CALCULATE% vagy %LOCK% akciót.%LINEBREAK% NETWORKED CALCULATIONS: Amikor védekezel vagy támadást hajtasz végre, elkölthetsz 1&nbsp;%CALCULATE% jelzőt egy 0-1-es távolságban lévő baráti hajóról, hogy megváltoztass 1&nbsp;%FOCUS% eredményt %EVADE% vagy %HIT% eredményre."""
        "DFS-081":
           text: """Amikor egy baráti hajó 0-1 távolságban védekezik, elkölthet 1&nbsp;%CALCULATE% jelzőt, hogy az összes %CRIT% eredményt %HIT% eredményre változtassa.%LINEBREAK% NETWORKED CALCULATIONS: Amikor védekezel vagy támadást hajtasz végre, elkölthetsz 1&nbsp;%CALCULATE% jelzőt egy 0-1-es távolságban lévő baráti hajóról, hogy megváltoztass 1&nbsp;%FOCUS% eredményt %EVADE% vagy %HIT% eredményre."""
        "Obi-Wan Kenobi":
           text: """Miután egy baráti hajó 0-2-es távolságban elkölt egy %FOCUS% jelzőt, elkölthetsz 1&nbsp;%FORCE% jelzőt. Ha így teszel, az a hajó kap 1&nbsp;%FOCUS% jelzőt.%LINEBREAK% FINE-TUNED CONTROLS: Miután teljesen végrehajtasz egy manővert, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy végrehajts egy %BOOST% vagy %BARRELROLL% akciót."""
        "Jedi Knight":
           text: """FINE-TUNED CONTROLS: Miután teljesen végrehajtasz egy manővert, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy végrehajts egy %BOOST% vagy %BARRELROLL% akciót.""" 
        "Ahsoka Tano":
           text: """Miután teljesen végrehajtasz egy manővert, választhatsz egy baráti hajót 0-1-es távolságban és költs el 1&nbsp;%FORCE% jelzőt. Az a hajó végrehajthat egy akciót még ha stresszes is. %LINEBREAK% FINE-TUNED CONTROLS: Miután teljesen végrehajtasz egy manővert, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy végrehajts egy %BOOST% vagy %BARRELROLL% akciót.""" 
        "Anakin Skywalker":
           text: """Miután teljesen végrehajtasz egy manővert, ha van egy ellenséges hajó a %FRONTARC% tűzívedben 0-1 távolságban vagy a %BULLSEYEARC% tűzívedben, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy levegyél 1 stressz jelzőt.%LINEBREAK% FINE-TUNED CONTROLS: Miután teljesen végrehajtasz egy manővert, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy végrehajts egy %BOOST% vagy %BARRELROLL% akciót.""" 
        "Barriss Offee":
           text: """Amikor egy baráti hajó 0-2-es távolságban támadást hajt végre, ha a védekező benne van annak %BULLSEYEARC% tűzívében, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy átforgass 1&nbsp;%FOCUS% eredményt %HIT% eredményre vagy 1&nbsp;%HIT% eredményt %CRIT% eredményre.%LINEBREAK% FINE-TUNED CONTROLS: Miután teljesen végrehajtasz egy manővert, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy végrehajts egy %BOOST% vagy %BARRELROLL% akciót.""" 
        "Luminara Unduli":
           text: """Amikor egy baráti hajó 0-2-es távolságban védekezik, ha az nincs a támadó %BULLSEYEARC% tűzívében, elkölthetsz 1&nbsp;%FORCE% jelzőt. Ha így teszel, forgass át 1&nbsp;%CRIT% eredményt %HIT% eredményre vagy 1&nbsp;%HIT% eredményt %FOCUS% eredményre.%LINEBREAK% FINE-TUNED CONTROLS: Miután teljesen végrehajtasz egy manővert, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy végrehajts egy %BOOST% vagy %BARRELROLL% akciót.""" 
        "Plo Koon":
           text: """Az Ütközet fázis elején elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy válassz egy másik baráti hajót 0-2-es távolságban. Ha így teszel, átadhatsz 1 zöld jelzőt neki vagy átvehetsz egy narancs jelzőt magadra.%LINEBREAK% FINE-TUNED CONTROLS: Miután teljesen végrehajtasz egy manővert, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy végrehajts egy %BOOST% vagy %BARRELROLL% akciót."""
        "Saesee Tiin":
           text: """Miután egy baráti hajó 0-2-es távolságban felfedi a tárcsáját elkölthetsz 1&nbsp;%FORCE% jelzőt. Ha így teszel, állítsd át a tárcsáját egy másik hasonló sebességű és nehézségű manőverre.%LINEBREAK% FINE-TUNED CONTROLS: Miután teljesen végrehajtasz egy manővert, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy végrehajts egy %BOOST% vagy %BARRELROLL% akciót."""
        "Mace Windu":
           text: """Miután teljesen végrehajtasz egy piros manővert, tölts vissza 1&nbsp;%FORCE% jelzőt.%LINEBREAK% FINE-TUNED CONTROLS: Miután teljesen végrehajtasz egy manővert, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy végrehajts egy %BOOST% vagy %BARRELROLL% akciót."""
        '"Kickback"':
           text: """Miután végrehajtasz egy %BARRELROLL% akciót, végrehajthatsz egy piros %LOCK% akciót."""
        '"Odd Ball"':
           text: """Miután teljesen végrehajtasz egy piros manővert vagy piros akciót, ha van egy ellenséges hajó a %BULLSEYEARC% tűzívedben, feltehetsz egy bemérőt arra a hajóra."""
        '"Sinker"':
           text: """Amikor egy baráti hajó 1-2-es távolságban a %LEFTARC% vagy %RIGHTARC% tűzívedben elsődleges támadást hajt végre, újradobhat 1 támadókockát."""
        '"Swoop"':
           text: """Miután egy baráti kis vagy közepes hajó teljesen végrehajt egy 3-4 sebességű manővert, ha az 0-1-es távolságban van tőled, végrehajthat egy piros %BOOST% akciót."""
        '"Axe"':
           text: """Miután védekezel vagy támadást hajtasz végre, választhatsz egy baráti hajót 1-2-es távolságban a %LEFTARC% vagy %RIGHTARC% tűzívedben. Ha így teszel add át 1 zöld jelződet annak a hajónak."""
        '"Tucker"':
           text: """Miután egy baráti hajó 1-2-es távolságban végrehajt egy támadást egy ellenséges hajó ellen a %FRONTARC% tűzívedben, végrehajthatsz egy %FOCUS% akciót."""
        "Bombardment Drone":
           text: """Amikor ledobnál egy eszközt, ki is lőheted, ugyanazt a sablont használva. %LINEBREAK% NETWORKED CALCULATIONS: Amikor védekezel vagy támadást hajtasz végre, elkölthetsz 1&nbsp;%CALCULATE% jelzőt egy 0-1-es távolságban lévő baráti hajóról, hogy megváltoztass 1&nbsp;%FOCUS% eredményt %EVADE% vagy %HIT% eredményre."""
        "Count Dooku":
           text: """Miután védekeztél, ha a támadó benne van a tűzívedben, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy levedd egy kék vagy piros jelződ.%LINEBREAK% Miután végrehajtasz egy támadást ami talált, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy végrehajts egy akciót."""
        "0-66":
           text: """Miután védekezel, elkölthetsz 1&nbsp;%CALCULATE% jelzőt, hogy végrehajts egy akciót."""
        "DFS-311":
           text: """Az Üzközet fázis elején, átteheted 1&nbsp;%CALCULATE% jelződet egy másik baráti hajóra 0-3-as távolságban. %LINEBREAK% NETWORKED CALCULATIONS: Amikor védekezel vagy támadást hajtasz végre, elkölthetsz 1&nbsp;%CALCULATE% jelzőt egy 0-1-es távolságban lévő baráti hajóról, hogy megváltoztass 1&nbsp;%FOCUS% eredményt %EVADE% vagy %HIT% eredményre."""
        '"Odd Ball" (ARC-170)':
           text: """Miután teljesen végrehajtasz egy piros manővert vagy piros akciót, ha van egy ellenséges hajó a %BULLSEYEARC% tűzívedben, feltehetsz egy bemérőt arra a hajóra."""
        '"Jag"':
           text: """Miután egy baráti hajó 1-2-es távolságban a %LEFTARC% vagy %RIGHTARC% tűzívedben védekezik, feltehetsz egy bemérőt a támadóra."""
        '"Wolffe"':
           text: """Amikor végrehajtasz egy elsődleges %FRONTARC% támadást, elkölthetsz 1 %CHARGE% jelzőt, hogy újradobj 1 támadókockát. %LINEBREAK% Amikor végrehajtasz egy elsődleges %REARARC% támadást, visszaállíthatsz 1 %CHARGE% jelzőt, hogy 1-gyel több támadókockával dobj"""

    upgrade_translations =
        "0-0-0":
           display_name: """0-0-0"""
           text: """<i>Söpredék vagy Darth Vader a csapatban</i>%LINEBREAK%Az Ütközet fázis elején, kiválaszthatsz 1 ellenséges hajót 0-1-es távolságban. Ha így teszel, kapsz egy kalkuláció jelzőt, hacsak a hajó nem választja, hogy kap 1 stressz jelzőt."""
        "4-LOM":
           display_name: """4-LOM"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Amikor végrehajtasz egy támadást, a támadókockák eldobása után, megnevezhetsz egy zöld jelző típust. Ha így teszel, kapsz 2 ion jelzőt és ezen támadás alatt a védekező nem költheti el a megnevezett típusú jelzőt."""
        "Andrasta":
           display_name: """Andrasta"""
           text: """<i>csak Söpredék</i>%LINEBREAK%<i>Kapott akció %RELOAD%</i>%LINEBREAK%Kapsz egy %DEVICE% fejlesztés helyet."""
        "Dauntless":
           display_name: """Dauntless"""
           text: """<i>csak Birodalom</i>%LINEBREAK%Miután részlegesen hajtottál végre egy manővert, végrehajthatsz 1 fehér akciót pirosként kezelve."""
        "Ghost":
           display_name: """Ghost"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Bedokkoltathatsz 1 Attack shuttle-t vagy Sheathipede-class shuttle-t. A dokkolt hajót csak a hátsó pöcköktől dokkolhatod ki."""
        "Havoc":
           display_name: """Havoc"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Elveszted a %CREW% fejlesztés helyet. Kapsz egy %SENSOR% és egy %ASTROMECH% fejlesztés helyet."""
        "Hound's Tooth":
           display_name: """Hound’s Tooth"""
           text: """<i>csak Söpredék</i>%LINEBREAK%1 Z-95-AF4 headhunter bedokkolhat."""
        "IG-2000":
           display_name: """IG-2000"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Megkapod minden másik <strong>IG-2000</strong> fejlesztéssel felszerelt baráti hajó pilóraképességét."""
        "Marauder":
           display_name: """Marauder"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Amikor végrehajtasz egy elsődleges %REARARC% támadást, újradobhatsz 1 támadókockádat. Kapsz egy %GUNNER% fejlesztés helyet."""
        "Millennium Falcon":
           display_name: """Millennium Falcon"""
           text: """<i>csak Lázadók</i>%LINEBREAK%<i>Kapott akció %EVADE%</i>%LINEBREAK%Amikor védekezel, ha van kitérés jelződ, újradobhatsz 1 védekezőkockát."""
        "Mist Hunter":
           display_name: """Mist Hunter"""
           text: """<i>csak Söpredék</i>%LINEBREAK%<i>Kapott akció %BARRELROLL%</i>%LINEBREAK%Kapsz egy %CANNON% fejlesztés helyet."""
        "Moldy Crow":
           display_name: """Moldy Crow"""
           text: """<i>csak Lázadók vagy Söpredék</i>%LINEBREAK%Kapsz egy %FRONTARC% elsődleges fegyvert 3-as támadóértékkel. A Vége fázis alatt megtarthatsz maximum 2 fókusz jelzőt."""
        "Outrider":
           display_name: """Outrider"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Amikor végrehajtasz egy támadást ami egy akadály által akadályozott, a védekező 1-gyel kevesebb védekezőkockával dob. Miután teljesen végrehajtasz egy manővert, ha áthaladtál vagy átfedésbe kerültél egy akadállyal, levehetsz 1 piros vagy narancs jelződet."""
        "Phantom":
           display_name: """Phantom"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Be tudsz dokkolni 0-1 távolságból."""
        "Punishing One":
           display_name: """Punishing One"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Amikor végrehajtasz egy elsődleges támadást, ha a védekező benne van a %FRONTARC% tűzívedben, dobj 1-gyel több támadókockával. Elveszted a %CREW% fejlesztés helyet. Kapsz egy %ASTROMECH% fejlesztés helyet."""
        "ST-321":
           display_name: """ST-321"""
           text: """<i>csak Birodalom</i>%LINEBREAK%Amikor végrehajtasz egy %COORDINATE% akciót, kiválaszthatsz egy ellenséges hajót 0-3-as távolságban a koordinált hajótól. Ha így teszel, tegyél fel egy bemérőt arra az ellenséges hajóra figyelmen kívül hagyva a távolság megkötéseket."""
        "Shadow Caster":
           display_name: """Shadow Caster"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Miután végrehajtasz egy támadást ami talál, ha a védekező benne van a %SINGLETURRETARC% és %FRONTARC% tűzívedben is, a védekező kap 1 vonósugár jelzőt."""
        "Slave I":
           display_name: """Slave I"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Miután felfedtél egy kanyar (%TURNLEFT% vagy %TURNRIGHT%) vagy ív (%BANKLEFT% vagy %BANKRIGHT%) manővert, átforgathatod a tárcsádat az ellenkező irányba megtartva a sebességet és a mozgásformát. Kapsz egy %TORPEDO% fejlesztés helyet."""
        "Virago":
           display_name: """Virago"""
           text: """<i>Kapsz egy %MODIFICATION% fejlesztés helyet. Adj 1 pajzs értéket a hajódhoz.</i>%LINEBREAK%A Vége fázis alatt, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy végrehajts egy piros %BOOST% akciót."""
        "Ablative Plating":
           display_name: """Ablative Plating"""
           text: """<i>közepes vagy nagy talp</i>%LINEBREAK%Mielőtt sérülést szenvednél egy akadálytól vagy baráti bomba robbanástól, elkölthetsz 1&nbsp;%CHARGE% jelzőt. Ha így teszel, megakadályozol 1 sérülést."""
        "Admiral Sloane":
           display_name: """Admiral Sloane"""
           text: """<i>csak Birodalom</i>%LINEBREAK%Miután másik baráti hajó 0-3 távolságban védekezik, ha megsemmisül a támadó kap 2 stressz jelzőt. Amikor egy baráti hajó 0-3 távolságban végrehajt egy támadást egy stresszelt hajó ellen, 1 támadókockát újradobhat."""
        "Adv. Proton Torpedoes":
           display_name: """Adv. Proton Torpedoes"""
           text: """<strong>Támadás (%LOCK%):</strong>Támadás (%LOCK%): Költs el 1&nbsp;%CHARGE% jelzőt. Változtass 1&nbsp;%HIT% eredményt %CRIT% eredményre."""
        "Advanced SLAM":
           display_name: """Advanced SLAM"""
           text: """<i>Követelmény: %SLAM%</i>%LINEBREAK%Miután végrehajtasz egy %SLAM% akciót, ha teljesen végrehajtod azt a manővert, végrehajthatsz egy fehér akciót az akciósávodról pirosként kezelve."""
        "Advanced Sensors":
           display_name: """Advanced Sensors"""
           text: """Miután felfeded a tárcsádat, végrehajthatsz 1 akciót. Ha így teszel, nem hajthatsz végre másik akciót a saját aktivációdban."""
        "Afterburners":
           display_name: """Afterburners"""
           text: """<i>csak kis hajó</i>%LINEBREAK%Miután teljesen végrehajtasz egy 3-5 sebességű manővert, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy végrehajts egy %BOOST% akciót, még ha stresszes is vagy."""
        "Agent Kallus":
           display_name: """Agent Kallus"""
           text: """<i>csak Birodalom</i>%LINEBREAK%<strong>Felhelyezés:</strong> rendelt hozzá a <strong>Hunted</strong> kondíciót 1 ellenséges hajóhoz. Amikor végrehajtasz egy támadást a <strong>Hunted</strong> kondícióval rendelkező hajó ellen, 1&nbsp;%FOCUS% eredményed %HIT% eredményre változtathatod."""
        "Agile Gunner":
           display_name: """Agile Gunner"""
           text: """A Vége fázisban elforgathatod a %SINGLETURRETARC% mutatódat."""
        "BT-1":
           display_name: """BT-1"""
           text: """<i>Söpredék vagy Darth Vader a csapatban</i>%LINEBREAK%Amikor végrehajtasz egy támadást, megváltoztathatsz 1&nbsp;%HIT% eredményt %CRIT% eredményre minden stressz jelző után ami a védekezőnek van."""
        "Barrage Rockets":
           display_name: """Barrage Rockets"""
           text: """<strong>Támadás (%FOCUS%):</strong> Költs el 1&nbsp;%CHARGE% jelzőt. Ha a védekező benne van a %BULLSEYEARC% tűzívedben, elkölthetsz 1 vagy több %CHARGE% jelzőt, hogy újradobj azzal egyenlő számú támadókockát."""
        "Baze Malbus":
           display_name: """Baze Malbus"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Amikor végrehajtasz egy %FOCUS% akciót, kezelheted pirosként. Ha így teszel minden egyes 0-1 távolságban lévő ellenséges hajó után kapsz 1 további fókusz jelzőt, de maximum 2 darabot."""
        "Bistan":
           display_name: """Bistan"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Amikor végrehajtasz egy elsődleges támadást, ha van fókusz jelződ, végrehajthatsz egy bónusz %SINGLETURRETARC% támadást egy olyan hajó ellen, akit még nem támadtál ebben a körben."""
        "Boba Fett":
           display_name: """Boba Fett"""
           text: """<i>csak Söpredék</i>%LINEBREAK%<strong>Felhelyezés:</strong> tartalékban kezdesz. A Felrakási fázis végén tedd a hajód 0 távolságra egy akadálytól, de 3-as távolságon túl az ellenséges hajóktól."""
        "Bomblet Generator":
           display_name: """Bomblet Generator"""
           text: """<strong>Bomba</strong>%LINEBREAK%A Rendszer fázisban elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy ledobd a Bomblet bombát a [1&nbsp;%STRAIGHT%] sablonnal. Az Aktivációs fázis elején elkölthetsz 1 pajzsot, hogy visszatölts 2 %CHARGE% jelzőt."""
        "Bossk":
           display_name: """Bossk"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Amikor végrehajtasz egy elsődleges támadást ami nem talál, ha nem vagy stresszes kapsz 1 stressz jelzőt, hogy végrehajts egy bónusz támadást ugyanazon célpont ellen."""
        "C-3PO":
           display_name: """C-3PO"""
           text: """<i>Kapott akció: %CALCULATE%</i>%LINEBREAK%<i>csak Lázadók</i>%LINEBREAK%Védekezőkocka gurítás előtt, elkölthetsz 1&nbsp;%CALCULATE% jelzőt hogy hangosan tippelhess egy 1 vagy nagyobb számra. Ha így teszel és pontosan annyi %EVADE% eredményt dobsz, adjál hozzá még 1&nbsp;%EVADE% eredményt. Miután végrehajtasz a %CALCULATE% akciót, kapsz 1&nbsp;%CALCULATE% jelzőt."""
        "Cad Bane":
           display_name: """Cad Bane"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Miután ledobsz vagy kilősz egy eszközt, végrehajthatsz egy piros %BOOST% akciót."""
        "Cassian Andor":
           display_name: """Cassian Andor"""
           text: """<i>csak Lázadók</i>%LINEBREAK%A Rendszer fázis alatt választhatsz 1 ellenséges hajót 1-2-es távolságban. Tippeld meg hangosan manővere irányát és sebességét, aztán nézd meg a tárcsáját. Ha az iránya és sebessége egyezik a tippeddel, megváltoztathatod a saját tárcsádat egy másik manőverre."""
        "Chewbacca":
           display_name: """Chewbacca"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Az Ütközet fázis elején elkölthetsz 2&nbsp;%CHARGE% jelzőt, hogy megjavíts 1 felfordított sérülés kártyát."""
        "Chewbacca (Scum)":
           display_name: """Chewbacca"""
           text: """<i>csak Söpredék</i>%LINEBREAK%A Vége fázis elején elkölthetsz 1&nbsp;%FOCUS% jelzőt, hogy megjavíts 1 felfordított sérülés kártyát."""
        "Ciena Ree":
           display_name: """Ciena Ree"""
           text: """<i>Követelmény %COORDINATE% vagy <r>%COORDINATE%</r></i>%LINEBREAK%<i>csak Birodalom</i>%LINEBREAK%Miután végrehajtasz egy %COORDINATE% akciót, ha a koordinált hajó végrehajt egy %BARRELROLL% vagy %BOOST% akciót, kaphat 1 stressz jelzőt, hogy elforduljon 90 fokot."""
        "Cikatro Vizago":
           display_name: """Cikatro Vizago"""
           text: """<i>csak Söpredék</i>%LINEBREAK%A Vége fázis alatt, választhatsz 2&nbsp;%ILLICIT% fejlesztést ami baráti hajókra van felszerelve 0-1-es távolságban. Ha így teszel, megcserélheted ezeket a fejlesztéseket. A játék végén: tegyél vissza minden %ILLICIT% fejlesztést az eredeti hajójára."""
        "Cloaking Device":
           display_name: """Cloaking Device"""
           text: """<i>kis vagy közepes talp</i>%LINEBREAK%<strong>Akció:</strong> költs el 1&nbsp;%CHARGE% jelzőt, hogy végrehajts egy %CLOAK% akciót. A tervezési fázis elején dobj 1 támadó kockával. %FOCUS% eredmény esetén hozd ki a hajód álcázásból vagy vedd le az álcázás jelzőt."""
        "Cluster Missiles":
           display_name: """Cluster Missiles"""
           text: """<strong>Támadás (%LOCK%):</strong> Költs el 1&nbsp;%CHARGE% jelzőt. Ezen támadás után végrehajthatod ezt a támadást, mint bónusz támadás egy másik célpont ellen 0-1 távolságra a védekezőtől, figyelmen kívül hagyva a %LOCK% követelményt."""
        "Collision Detector":
           display_name: """Collision Detector"""
           text: """Amikor orsózol vagy gyorsítasz átmozoghatsz vagy rámozoghatsz akadályra. Miután átmozogtál vagy rámozogtál egy akadályra, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy figyelmen kívül hagyhatsd az akadály hatását a kör végéig."""
        "Composure":
           display_name: """Composure"""
           text: """<i>Követelmény <r>%FOCUS%</r> vagy %FOCUS%</i>%LINEBREAK%Ha nem sikerül végrehajtani egy akciót és nincs zöld jelződ, végrehajthatsz egy %FOCUS% akciót."""
        "Concussion Missiles":
           display_name: """Concussion Missiles"""
           text: """<strong>Támadás (%LOCK%):</strong> Költs el 1&nbsp;%CHARGE% jelzőt. Ha a támadás talált, a védekezőtől 0-1 távolságban lévő minden hajó felfordítja egy sérülés kártyáját."""
        "Conner Nets":
           display_name: """Conner Nets"""
           text: """<strong>Akna</strong>%LINEBREAK%A Rendszer fázisban elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy ledobj egy Conner Net aknát a [1&nbsp;%STRAIGHT%] sablonnal. Ennak a kártyának a %CHARGE% jelzője <strong>nem</strong> újratölthető."""
        "Contraband Cybernetics":
           display_name: """Contraband Cybernetics"""
           text: """Mielőtt aktiválódnál, elkölthetsz 1&nbsp;%CHARGE% jelzőt. Ha így teszel, a kör végéig végrehajthatsz akciókat és piros manővereket, még stresszesen is."""
        "Crack Shot":
           display_name: """Crack Shot"""
           text: """Amikor végrehajtasz egy elsődleges támadást, ha a védekező benne van a %BULLSEYEARC% tűzívedben, még az <strong>Eredmények semlegesítése</strong> lépés előtt elkölthetsz 1&nbsp;%CHARGE% jelzőt hogy hatástalaníts 1&nbsp;%EVADE% eredményt."""
        "Daredevil":
           display_name: """Daredevil"""
           text: """<i>Követelmény %BOOST%</i>%LINEBREAK%<i>csak kis hajó</i>%LINEBREAK%Amikor végrehajtasz egy fehér %BOOST% akciót, kezelheted pirosként, hogy a [1&nbsp;%TURNLEFT%] vagy [1&nbsp;%TURNRIGHT%] sablokokat használhasd."""
        "Darth Vader":
           display_name: """Darth Vader"""
           text: """<i>csak Birodalom</i>%LINEBREAK%Az Ütközet fázis elején, válaszhatsz 1 hajót a tűzívedben 0-2-es távolságban és költs el 1&nbsp;%FORCE% jelzőt. Ha így teszel, az a hajó elszenved 1&nbsp;%HIT% sérülést, hacsak úgy nem dönt, hogy eldob 1 zöld jelzőt."""
        "Deadman's Switch":
           display_name: """Deadman’s Switch"""
           text: """Miután megsemmisültél, minden hajó 0-1 távolságban elszenved 1&nbsp;%HIT% sérülést."""
        "Death Troopers":
           display_name: """Death Troopers"""
           text: """<i>csak Birodalom</i>%LINEBREAK%Az Aktivációs fázis alatt az ellenséges hajók 0-1-es távolságban nem vehetik le a stressz jelzőjüket."""
        "Debris Gambit":
           display_name: """Debris Gambit"""
           text: """<i>Kapott akció: <r>%EVADE%</r></i>%LINEBREAK%<i>csak kis vagy közepes hajó</i>%LINEBREAK%Amikor végrehajtasz egy piros %EVADE% akciót, ha van 0-1-es távolságban egy akadály, kezeld az akciót fehérként."""
        "Dengar":
           display_name: """Dengar"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Miután védekezel, ha a támadó a tűzívedben van, elkölthetsz 1&nbsp;%CHARGE% jelzőt. Ha így teszel, dobj 1 támadókockával, hacsak a támadó úgy nem dönt, hogy eldobja 1 zöld jelzőjét. %HIT% vagy %CRIT% eredmény esetén a támadó elszenved 1&nbsp;%HIT% sérülést."""
        "Director Krennic":
           display_name: """Director Krennic"""
           text: """<i>Kapott akció %LOCK%</i>%LINEBREAK%<i>csak Birodalom</i>%LINEBREAK%<strong>Felhelyezés:</strong> a hajók felhelyezése előtt, rendeld hozzá az <strong>Optimized Prototype</strong> kondíciót egy másik baráti hajóhoz."""
        "Dorsal Turret":
           display_name: """Dorsal Turret"""
           text: """<i>Kapott akció %ROTATEARC%</i>%LINEBREAK%<strong>Támadás</strong>"""
        "Electronic Baffle":
           display_name: """Electronic Baffle"""
           text: """A Vége fázis alatt, elszenvedhetsz 1&nbsp;%HIT% sérülést, hogy levegyél 1 piros jelzőt."""
        "Elusive":
           display_name: """Elusive"""
           text: """<i>csak kis vagy közepes hajó</i>%LINEBREAK%Amikor védekezel, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy újradobj 1 védekezőkockát. Miután teljesen végrehajtasz egy piros manővert, visszatölthetsz 1&nbsp;%CHARGE% jelzőt."""
        "Emperor Palpatine":
           display_name: """Emperor Palpatine"""
           text: """<i>csak Birodalom</i>%LINEBREAK%Amikor egy másik baráti hajó védekezik vagy végrehajt egy támadást, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy módosít annak 1 kockáját úgy, mintha az a hajó költött volna el 1&nbsp;%FORCE% jelzőt."""
        "Engine Upgrade":
           display_name: """Engine Upgrade"""
           text: """<i>Kapott akció %BOOST%</i>%LINEBREAK%<i>Követelmény <r>%BOOST%</r></i>%LINEBREAK%<i class = flavor_text>Ennek a fejlesztésnek változó a költsége. 3, 6 vagy 9 pont attól függően, hogy kis, közepes vagy nagy talpú hajóra tesszük fel.</i>"""
        "Expert Handling":
           display_name: """Expert Handling"""
           text: """<i>Kapott akció %BARRELROLL%</i>%LINEBREAK%<i>Követelmény <r>%BARRELROLL%</r></i>%LINEBREAK%<i class = flavor_text>Ennek a fejlesztésnek változó a költsége. 2, 4 vagy 6 pont attól függően, hogy kis, közepes vagy nagy talpú hajóra tesszük fel.</i>"""
        "Ezra Bridger":
           display_name: """Ezra Bridger"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Amikor végrehajtasz egy elsődleges támadást, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy végrehajts egy bónusz %SINGLETURRETARC% támadást egy olyan %SINGLETURRETARC% fegyverrel, amivel még nem támadtál ebben a körben. Ha így teszel és stresszes vagy, újradobhatsz 1 támadókockát."""
        "Fearless":
           display_name: """Fearless"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Amikor végrehajtasz egy %FRONTARC% elsődleges támadást, ha a támadási távolság 1 és benne vagy a védekező %FRONTARC% tűzívében, megváltoztathatsz 1 eredményedet %HIT% eredményre."""
        "Feedback Array":
           display_name: """Feedback Array"""
           text: """Mielőtt sor kerül rád az Üzközet fázisban, kaphatsz 1 ion jelzőt és 1 'inaktív fegyverzet' jelzőt. Ha így teszel, minden hajó 0-ás távolságban elszenved 1&nbsp;%HIT% sérülést."""
        "Fifth Brother":
           display_name: """Fifth Brother"""
           text: """<i>csak Birodalom</i>%LINEBREAK%Amikor végrehajtasz egy támadást, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy megváltoztass 1&nbsp;%FOCUS% eredményed %CRIT% eredményre."""
        "Fire-Control System":
           display_name: """Fire-Control System"""
           text: """Amikor végrehajtasz egy támadást, ha van bemérőd a védekezőn, újradobhatod 1 támadókockádat. Ha így teszel, nem költheted el a bemérődet ebben a támadásban."""
        "Freelance Slicer":
           display_name: """Freelance Slicer"""
           text: """Amikor védekezel, mielőtt a támadó kockákat eldobnák, elköltheted a támadón lévő bemérődet, hogy dobj 1 támadókockával. Ha így teszel, a támadó kap 1 zavarás jelzőt. Majd %HIT% vagy %CRIT% eredménynél te is kapsz 1 zavarás jelzőt."""
        'GNK "Gonk" Droid':
           display_name: """GNK “Gonk” Droid"""
           text: """<strong>Felhelyezés:</strong> Elvesztesz 1&nbsp;%CHARGE% jelzőt.%LINEBREAK%<strong>Akció:</strong> tölts vissza 1&nbsp;%CHARGE% jelzőt. <strong>Akció:</strong>: költs el 1&nbsp;%CHARGE% jelzőt, hogy visszatölts egy pajzsot."""
        "Grand Inquisitor":
           display_name: """Grand Inquisitor"""
           text: """<i>csak Birodalom</i>%LINEBREAK%Miután egy ellenséges hajó 0-2-es távolságban felfedi a tárcsáját, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy végrehajts 1 fehér akciót az akciósávodról, pirosként kezelve azt."""
        "Grand Moff Tarkin":
           display_name: """Grand Moff Tarkin"""
           text: """<i>Követelmény %LOCK% vagy <r>%LOCK%</r></i>%LINEBREAK%<i>csak Birodalom</i>%LINEBREAK%A Rendszer fázis alatt elkölthetsz 2&nbsp;%CHARGE% jelzőt. Ha így teszel, minden baráti hajó kap egy bemérőt arra a hajóra, amit te is bemértél."""
        "Greedo":
           display_name: """Greedo"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Amikor végrehajtasz egy támadást, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy megváltoztass 1&nbsp;%HIT% eredméynyt %CRIT% eredményre. Amikor védekezel, ha a %CHARGE% jelződ aktív, a támadó megváltoztathat 1&nbsp;%HIT% eredméynyt %CRIT% eredményre."""
        "Han Solo":
           display_name: """Han Solo"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Az Ütközet fázis alatt, 7-es kezdeményezésnél, végrehajthatsz egy %SINGLETURRETARC% támadást. Nem támadhatsz újra ezzel a %SINGLETURRETARC% fegyverrel ebben a körben."""
        "Han Solo (Scum)":
           display_name: """Han Solo"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Mielőtt sor kerül rád az Üzközet fázisban, végrehajthatsz egy piros %FOCUS% akciót."""
        "Heavy Laser Cannon":
           display_name: """Heavy Laser Cannon"""
           text: """<strong>Támadás:</strong> a <strong>Támadókockák módosítása</strong> lépés után változtasd az összes %CRIT% eredményt %HIT% eredményre."""
        "Heightened Perception":
           display_name: """Heightened Perception"""
           text: """Az Ütközet fázis elején, elkölthetsz 1&nbsp;%FORCE% jelzőt. Ha így teszel, 7-es kezdeményezéssel kerülsz sorra ebben a fázisban a rendes kezdeményezésed helyett."""
        "Hera Syndulla":
           display_name: """Hera Syndulla"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Stresszesen is végrehajthatsz piros manővert. Miután teljesen végrehajtasz egy piros manővert, ha 3 vagy több stressz jelződ van, vegyél le egy stressz jelzőt és szenvedj el 1&nbsp;%HIT% sérülést."""
        "Homing Missiles":
           display_name: """Homing Missiles"""
           text: """<strong>Támadás (%LOCK%):</strong> Költs el 1&nbsp;%CHARGE% jelzőt. Miután kijelölted a védekezőt, a védekező dönthet úgy, hogy elszenved 1&nbsp;%HIT% sérülést. Ha így tesz, ugorjátok át a <strong>Támadó és védekező kockák</strong> lépést és a támadást találtnak kezeljétek."""
        "Hotshot Gunner":
           display_name: """Hotshot Gunner"""
           text: """Amikor végrehajtasz egy %SINGLETURRETARC% támadást, a <strong>Védekezőkockák módosítása</strong> lépés után a védekező dobja el 1 fókusz vagy kalkuláció jelzőjét."""
        "Hull Upgrade":
           display_name: """Hull Upgrade"""
           text: """Adj 1 szerkezeti értéket a hajódhoz.%LINEBREAK%<i>Ennek a fejlesztésnek változó a költsége. 2, 3, 5 vagy 7 pont attól függően, hogy a hajó 0, 1, 2 vagy 3 védekezésű.</i>"""
        "IG-88D":
           display_name: """IG-88D"""
           text: """<i>Kapott akció %CALCULATE%</i>%LINEBREAK%<i>csak Söpredék</i>%LINEBREAK%Megkapod minden <strong>IG-2000</strong> fejlesztéssel felszerelt baráti hajó pilóraképességét. Miután végrehajtasz egy %CALCULATE% akciót, kapsz 1 kalkuláció jelzőt."""
        "ISB Slicer":
           display_name: """ISB Slicer"""
           text: """<i>csak Birodalom</i>%LINEBREAK%A Vége fázis alatt az ellenséges hajók 1-2-es távban nem vehetik le a zavarás jelzőket."""
        "Inertial Dampeners":
           display_name: """Inertial Dampeners"""
           text: """Mielőtt végrehajtanál egy manővert, elkölthetsz 1 pajzsot. Ha így teszel, hajts végre egy fehér [0&nbsp;%STOP%] manővert a tárcsázott helyett, aztán kapsz 1 stressz jelzőt."""
        "Informant":
           display_name: """Informant"""
           text: """<strong>Felhelyezés:</strong> a hajók felhelyezése után válassz 1 ellenséges hajót és rendeld hozzá a <strong>Listening Device</strong> kondíciót."""
        "Instinctive Aim":
           display_name: """Instinctive Aim"""
           text: """Amikor végrehajtasz egy speciális támadást, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy figyelmen kívül hagyhatsd a %FOCUS% vagy %LOCK% követelményt."""
        "Intimidation":
           display_name: """Intimidation"""
           text: """Amikor egy ellenséges hajó 0-ás távolságban védekezik, 1-gyel kevesebb védekezőkockával dob."""
        "Ion Cannon":
           display_name: """Ion Cannon"""
           text: """<strong>Támadás:</strong> ha a támadás talált, költs 1&nbsp;%HIT% vagy %CRIT% eredményt, hogy a védekező elszenvedjen 1&nbsp;%HIT% sérülést. Minden fennmaradó %HIT%/%CRIT% eredmény után sérülés helyett ion jelzőt kap a védekező."""
        "Ion Cannon Turret":
           display_name: """Ion Cannon Turret"""
           text: """<i>Kapott akció %ROTATEARC%</i>%LINEBREAK%<strong>Támadás:</strong> ha a támadás talált, költs 1&nbsp;%HIT% vagy %CRIT% eredményt, hogy a védekező elszenvedjen 1&nbsp;%HIT% sérülést. Minden fennmaradó %HIT%/%CRIT% eredmény után sérülés helyett ion jelzőt kap a védekező."""
        "Ion Missiles":
           display_name: """Ion Missiles"""
           text: """<strong>Támadás (%LOCK%):</strong> költs el 1&nbsp;%CHARGE% jelzőt. ha a támadás talált, költs 1&nbsp;%HIT% vagy %CRIT% eredményt, hogy a védekező elszenvedjen 1&nbsp;%HIT% sérülést. Minden fennmaradó %HIT%/%CRIT% eredmény után sérülés helyett ion jelzőt kap a védekező."""
        "Ion Torpedoes":
           display_name: """Ion Torpedoes"""
           text: """<strong>Támadás (%LOCK%):</strong> költs el 1&nbsp;%CHARGE% jelzőt. ha a támadás talált, költs 1&nbsp;%HIT% vagy %CRIT% eredményt, hogy a védekező elszenvedjen 1&nbsp;%HIT% sérülést. Minden fennmaradó %HIT%/%CRIT% eredmény után sérülés helyett ion jelzőt kap a védekező."""
        "Jabba the Hutt":
           display_name: """Jabba the Hutt"""
           text: """<i>csak Söpredék</i>%LINEBREAK%A Vége fázis alatt, kiválaszthatsz 1 baráti hajót 0-2-es távolságban, majd költs el 1&nbsp;%CHARGE% jelzőt. Ha így teszel, a kiválasztott hajó visszatölthet 1&nbsp;%CHARGE% jelzőt 1 felszerelt %ILLICIT% fejlesztésén."""
        "Jamming Beam":
           display_name: """Jamming Beam"""
           text: """<strong>Támadás:</strong> ha a támadás talált, minden %HIT%/%CRIT% eredmény után sérülés helyett zavarás jelzőt kap a védekező."""
        "Juke":
           display_name: """Juke"""
           text: """<i>csak kis vagy közepes hajó</i>%LINEBREAK%Amikor végrehajtasz egy támadást, ha van kitérés jelződ, megváltoztathatod a védekező 1&nbsp;%EVADE% eredményét %FOCUS% eredményre."""
        "Jyn Erso":
           display_name: """Jyn Erso"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Ha egy baráti hajó 0-3 távolságban fókusz jelzőt kapna, helyette kaphat 1 kitérés jelzőt."""
        "Kanan Jarrus":
           display_name: """Kanan Jarrus"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Miután egy baráti hajó 0-2-es távolságban teljesen végrehajt egy fehér manővert, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy levegyél róla 1 stressz jelzőt."""
        "Ketsu Onyo":
           display_name: """Ketsu Onyo"""
           text: """<i>csak Söpredék</i>%LINEBREAK%A Vége fázis elején, kiválaszthatsz 1 ellenséges hajót 0-2-es távolságban a tűzívedben. Ha így teszel, aza a hajó nem veheti le a vonósugár jelzőit."""
        "L3-37":
           display_name: """L3-37"""
           text: """<i>csak Söpredék</i>%LINEBREAK%<strong>Felhelyezés:</strong> felfordítva szereld fel ezt a kártyát. Amikor védekezel, lefordíthatod ezt a kártyát. Ha így teszel, a támadónak újra kell dobnia az összes támadókockát.%LINEBREAK%<i>L3-37 programja:</i> Ha nincs pajzsod, csökkentsd a nehézségét a (%BANKLEFT% és %BANKRIGHT%) manővereknek."""
        "Lando Calrissian":
           display_name: """Lando Calrissian"""
           text: """<i>csak Lázadók</i>%LINEBREAK%<strong>Akció:</strong> dobj 2 védekezőkockával. Minden egyes %FOCUS% eredmény után kapsz 1 fókusz jelzőt. Minden egyes %EVADE% eredmény után kapsz 1 kitérés jelzőt. Ha mindkettő eredmény üres, az ellenfeled választ, hogy fókusz vagy kitérés. Kapsz 1, a választásnak megfelelő jelzőt."""
        "Lando Calrissian (Scum)":
           display_name: """Lando Calrissian"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Kockadobás után elkölthetsz 1 zöld jelzőt, hogy újradobj 2 kockádat."""
        "Lando's Millennium Falcon":
           display_name: """Lando’s Millennium Falcon"""
           text: """<i>csak Söpredék</i>%LINEBREAK%1 Escape Craft be lehet dokkolva. Amikor egy Escape Craft be van dokkolva, elköltheted a pajzsait, mintha a te hajódon lenne. Amikor végrehajtasz egy elsődleges támadást stresszelt hajó ellen, dobj 1-gyel több támadókockával."""
        "Latts Razzi":
           display_name: """Latts Razzi"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Amikor védekezel, ha a támadó stresszelt, levehetsz 1 stressz jelzőt a támadóról, hogy megváltoztass 1 üres/%FOCUS% eredményed %EVADE% eredményre."""
        "Leia Organa":
           display_name: """Leia Organa"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Az Aktivációs fázis elején, elkölthetsz 3&nbsp;%CHARGE% jelzőt. Ezen fázis alatt minden baráti hajó csökkentse a piros manőverei nehézségét."""
        "Lone Wolf":
           display_name: """Lone Wolf"""
           text: """Amikor védekezel vagy támadást hajtasz végre, ha nincs másik baráti hajó 0-2-es távolságban, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy újradobj 1 kockádat."""
        "Luke Skywalker":
           display_name: """Luke Skywalker"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Az Ütközet fázis elején, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy forgasd a %SINGLETURRETARC% mutatódat."""
        "Magva Yarro":
           display_name: """Magva Yarro"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Miután védekezel, ha a támadás talált, feltehetsz egy bemérőt a támadóra."""
        "Marksmanship":
           display_name: """Marksmanship"""
           text: """Amikor végrehajtasz egy támadást, ha a védekező benne van a %BULLSEYEARC% tűzívedben, megváltoztathatsz 1&nbsp;%HIT% eredményt %CRIT% eredményre."""
        "Maul":
           display_name: """Maul"""
           text: """<i>Söpredék vagy Ezra Bridger a csapatban</i>%LINEBREAK%Miután sérülést szenvedsz, kaphatsz 1 stressz jelzőt, hogy visszatölts 1&nbsp;%FORCE% jelzőt. Felszerelhetsz <strong>Dark Side</strong> fejlesztéseket."""
        "Minister Tua":
           display_name: """Minister Tua"""
           text: """<i>csak Birodalom</i>%LINEBREAK%Az Ütközet fázis elején, ha sérült vagy, végrehajthatsz egy piros %REINFORCE% akciót."""
        "Moff Jerjerrod":
           display_name: """Moff Jerjerrod"""
           text: """<i>Követelmény: %COORDINATE% vagy <r>%COORDINATE%</r></i>%LINEBREAK%<i>csak Birodalom</i>%LINEBREAK%A Rendszer fázis alatt, elkölthetsz 2&nbsp;%CHARGE% jelzőt. Ha így teszel, válassz a [1&nbsp;%BANKLEFT%], [1&nbsp;%STRAIGHT%] vagy [1&nbsp;%BANKRIGHT%] sablonokból. Minden baráti hajó végrehajthat egy piros %BOOST% akciót a kiválasztott sablonnal."""
        "Munitions Failsafe":
           display_name: """Munitions Failsafe"""
           text: """Amikor végrehajtasz egy %TORPEDO% vagy %MISSILE% támadást, a támadókockák eldobása után, elvetheted az összes kocka eredményed, hogy visszatölts 1&nbsp;%CHARGE% jelzőt, amit a támadáshoz elköltöttél."""
        "Nien Nunb":
           display_name: """Nien Nunb"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Csökkentsd az íves manőverek [%BANKLEFT% és %BANKRIGHT%] nehézségét."""
        "Novice Technician":
           display_name: """Novice Technician"""
           text: """A kör végén dobhatsz 1 támadó kockával, hogy megjavíts egy felfordított sérülés kártyát. %HIT% eredménynél, fordíts fel egy sérülés kártyát."""
        "Os-1 Arsenal Loadout":
           display_name: """Os-1 Arsenal Loadout"""
           text: """<i>Kapsz egy %TORPEDO% és egy %MISSILE% fejlesztés helyet.</i>%LINEBREAK%Amikor pontosan 1 'inaktív fegyverzet' jelződ van, akkor is végre tudsz hajtani %TORPEDO% és %MISSILE% támadást bemért célpontok ellen. Ha így teszel, nem használhatod el a bemérődet a támadás alatt."""
        "Outmaneuver":
           display_name: """Outmaneuver"""
           text: """Amikor végrehajtasz egy %FRONTARC% támadást, ha nem vagy a védekező tűzívében, a védekező 1-gyel kevesebb védekezőkockával dob."""
        "Perceptive Copilot":
           display_name: """Perceptive Copilot"""
           text: """Miután végrehajtasz egy %FOCUS% akciót, kapsz 1 fókusz jelzőt."""
        "Pivot Wing":
           display_name: """Pivot Wing"""
           text: """<strong>Csukva: </strong>Amikor védekezel, 1-gyel kevesebb védekezőkockával dobsz. Miután végrehajtasz egy [0&nbsp;%STOP%] manővert, elforgathatod a hajód 90 vagy 180 fokkal. Mielőtt aktiválódsz, megfordíthatod ezt a kártyát.%LINEBREAK%<strong>Nyitva:</Strong> Mielőtt aktiválódsz, megfordíthatod ezt a kártyát."""
        "Predator":
           display_name: """Predator"""
           text: """Amikor végrehajtasz egy elsődleges támadást, ha a védekező benne van a %BULLSEYEARC% tűzívedben, újradobhatsz 1 támadókockát."""
        "Proton Bombs":
           display_name: """Proton Bombs"""
           text: """<strong>Bomba</strong>%LINEBREAK%A Rendszer fázisban elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy kidobj egy Proton bombát az [1&nbsp;%STRAIGHT%] sablonnal."""
        "Proton Rockets":
           display_name: """Proton Rockets"""
           text: """<strong>Támadás (%FOCUS%):</strong> költs el 1&nbsp;%CHARGE% jelzőt."""
        "Proton Torpedoes":
           display_name: """Proton Torpedoes"""
           text: """<strong>Támadás (%LOCK%):</strong> költs el 1&nbsp;%CHARGE% jelzőt. Változtass 1&nbsp;%HIT% eredményt %CRIT% eredményre."""
        "Proximity Mines":
           display_name: """Proximity Mines"""
           text: """<strong>Akna</strong>%LINEBREAK%A Rendszer fázisban elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy ledobj egy Proximity aknát az [1&nbsp;%STRAIGHT%] sablonnal. Ennak a kártyának a %CHARGE% jelzője <strong>nem</strong> újratölthető."""
        "Qi'ra":
           display_name: """Qi’ra"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Amikor mozogsz vagy támadást hajtasz végre, figyelmen kívül hagyhatod az összes akadályt, amit bemértél."""
        "R2 Astromech":
           display_name: """R2 Astromech"""
           text: """Miután felfeded a tárcsád, elkölthetsz 1&nbsp;%CHARGE% jelzőt és kapsz 1 'inaktív fegyverzet' jelzőt, hogy visszatölts egy pajzsot."""
        "R2-D2 (Crew)":
           display_name: """R2-D2"""
           text: """<i>csak Lázadók</i>%LINEBREAK%A Vége fázis alatt, ha sérült vagy és nincs pajzsod, dobhatsz 1 támadókockával, hogy visszatölts 1 pajzsot. %HIT% eredménynél fordíts fel 1 sérüléskártyát."""
        "R2-D2":
           display_name: """R2-D2"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Miután felfeded a tárcsád, elkölthetsz 1&nbsp;%CHARGE% jelzőt és kapsz 1 'inaktív fegyverzet' jelzőt, hogy visszatölts egy pajzsot."""
        "R3 Astromech":
           display_name: """R3 Astromech"""
           text: """Fenntarthatsz 2 bemérőt. Mindegyik bemérő más célponton kell legyen. Miután végrehajtasz egy %LOCK% akciót, feltehetsz egy bemérőt."""
        "R4 Astromech":
           display_name: """R4 Astromech"""
           text: """<i>csak kis hajó</i>%LINEBREAK%Csökkentsd a nehézségét az 1-2 sebességű alapmanővereidnek (%TURNLEFT%, %BANKLEFT%, %STRAIGHT%, %BANKRIGHT%, %TURNRIGHT%)."""
        "R5 Astromech":
           display_name: """R5 Astromech"""
           text: """<strong>Akció:</strong> költs el 1&nbsp;%CHARGE% jelzőt, hogy megjavíts egy lefordított sérülés kártyát.%LINEBREAK%<strong>Akció:</strong> javíts meg 1 felfordított <strong>Ship</strong> sérülés kártyát."""
        "R5-D8":
           display_name: """R5-D8"""
           text: """<i>csak Lázadók</i>%LINEBREAK%<strong>Akció:</strong> költs el 1&nbsp;%CHARGE% jelzőt, hogy megjavíts egy lefordított sérülés kártyát.%LINEBREAK%<strong>Akció:</strong> javíts meg 1 felfordított <strong>Ship</strong> sérülés kártyát."""
        "R5-P8":
           display_name: """R5-P8"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Amikor végrehajtasz egy támadást a %FRONTARC% tűzívedben lévő védekező ellen, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy újradobj 1 támadókockát. Ha az újradobott eredmény %CRIT%, szenvedj el 1&nbsp;%CRIT% sérülést."""
        "R5-TK":
           display_name: """R5-TK"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Végrehajthatsz támadást baráti hajó ellen."""
        "Rigged Cargo Chute":
           display_name: """Rigged Cargo Chute"""
           text: """<i>csak közepes vagy nagy hajó</i>%LINEBREAK%<strong>Akció:</strong> költs el 1&nbsp;%CHARGE% jelzőt. Dobj ki 1 rakomány jelzőt az [1&nbsp;%STRAIGHT%] sablonnal."""
        "Ruthless":
           display_name: """Ruthless"""
           text: """<i>csak Birodalom</i>%LINEBREAK%Amikor végrehajtasz egy támadást, kiválaszthatsz másik baráti hajót 0-1-es távolságra a védekezőtől. Ha így teszel, a kiválasztott hajó elszenved 1&nbsp;%HIT% sérülést és te megváltoztathatsz 1 kocka eredményed %HIT% eredményre."""
        "Sabine Wren":
           display_name: """Sabine Wren"""
           text: """<i>csak Lázadók</i>%LINEBREAK%<strong>Felhelyezés:</strong> tegyél fel 1 ion, 1 zavarás, 1 stressz és 1 vonósugár jelzőt erre a kártyára. Miután egy hajó sérülést szenved egy baráti bombától, levehetsz 1 ion, 1 zavarás, 1 stressz vagy 1 vonósugár jelzőt erről a kártyáról. Ha így teszel, az a hajó megkapja ezt a jelzőt."""
        "Saturation Salvo":
           display_name: """Saturation Salvo"""
           text: """<i>Követelmény %RELOAD% vagy <r>%RELOAD%</r></i>%LINEBREAK%Amikor végrehajtasz egy %TORPEDO% vagy %MISSILE% támadást, elkölthetsz 1&nbsp;%CHARGE% jelzőt arról a kártyától. Ha így teszel, válassz 2 védekezőkockát. A védekezőnek újra kell dobnia azokat a kockákat."""
        "Saw Gerrera":
           display_name: """Saw Gerrera"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Amikor végrehajtasz egy támadást, elszenvedhetsz 1&nbsp;%HIT% sérülést, hogy megváltoztasd az összes %FOCUS% eredményed %CRIT% eredményre."""
        "Seasoned Navigator":
           display_name: """Seasoned Navigator"""
           text: """Miután felfedted a tárcsádat, átállíthatod egy másik nem piros manőverre ugyanazon sebességen. Amikor végrehajtod azt a manővert növeld meg a nehézségét."""
        "Seismic Charges":
           display_name: """Seismic Charges"""
           text: """<strong>Bomba</strong>%LINEBREAK%A Rendszer fázisban elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy ledobj egy Seismic Charge bombát az [1&nbsp;%STRAIGHT%] sablonnal."""
        "Selfless":
           display_name: """Selfless"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Amikor másik baráti hajó 0-1-es távolságban védekezik, az <strong>Eredmények semlegesítése</strong> lépés előtt, ha benne vagy a támadási tűzívben, elszenvedhetsz 1&nbsp;%CRIT% sérülést, hogy semlegesíts 1&nbsp;%CRIT% eredményt."""
        "Sense":
           display_name: """Sense"""
           text: """A Rendszer fázis alatt kiválaszthatsz 1 hajót 0-1-es távolságban és megnézheted a tárcsáját. Ha elköltesz 1&nbsp;%FORCE% jelzőt választhatsz 0-3-as távolságból hajót."""
        "Servomotor S-Foils":
           display_name: """Servomotor S-foils"""
           text: """<strong>Csukva: </strong><i>Kapott akciók: %BOOST% , %FOCUS%&nbsp;<i class="xwing-miniatures-font xwing-miniatures-font-linked"></i>&nbsp;<r>%BOOST%</r></i>%LINEBREAK% Amikor végrehajtasz egy elsődleges támadást, 1-gyel kevesebb támadókockával dobj.%LINEBREAK%Mielőtt aktiválódsz, megfordíthatod ezt a kártyát.%LINEBREAK%<strong>Nyitva:</strong> Mielőtt aktiválódsz, megfordíthatod ezt a kártyát."""
        "Seventh Sister":
           display_name: """Seventh Sister"""
           text: """<i>csak Birodalom</i>%LINEBREAK%Ha egy ellenséges hajó 0-1-es távolságra egy stressz jelzőt kapna, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy 1 zavarás vagy vonósugár jelzőt kapjon helyette."""
        "Shield Upgrade":
           display_name: """Shield Upgrade"""
           text: """Adj 1 pajzs értéket a hajódhoz.%LINEBREAK%<i>Ennek a fejlesztésnek változó a költsége. 3, 4, 6 vagy 8 pont attól függően, hogy a hajó 0, 1, 2 vagy 3 védekezésű.</i>"""
        "Skilled Bombardier":
           display_name: """Skilled Bombardier"""
           text: """Ha ledobsz vagy kilősz egy eszközt, megegyező irányban használhatsz 1-gyel nagyob vagy kisebb sablont."""
        "Squad Leader":
           display_name: """Squad Leader"""
           text: """<i>Kapott akció <r>%COORDINATE%</r></i>%LINEBREAK%WAmikor koordinálsz, a kiválasztott hajó csak olyan akciót hajthat végre, ami a te akciósávodon is rajta van."""
        "Static Discharge Vanes":
           display_name: """Static Discharge Vanes"""
           text: """Mielőtt kapnál 1 ion vagy zavarás jelzőt, ha nem vagy stresszes, választhatsz egy másik hajót 0-1-es távolságban és kapsz 1 stressz jelzőt. Ha így teszel, a kiválasztott hajó kapja meg az ion vagy zavarás jelzőt helyetted."""
        "Stealth Device":
           display_name: """Stealth Device"""
           text: """Amikor védekezel, ha a %CHARGE% jelződ aktív, dobj 1-gyel több védekezőkockával. Miután elszenvedsz egy sérülés, elvesztesz 1&nbsp;%CHARGE% jelzőt.%LINEBREAK%<i>Ennek a fejlesztésnek változó a költsége. 3, 4, 6 vagy 8 pont attól függően, hogy a hajó 0, 1, 2 vagy 3 védekezésű.</i>"""
        "Supernatural Reflexes":
           display_name: """Supernatural Reflexes"""
           text: """<i>csak kis hajó</i>%LINEBREAK%Mielőtt aktiválódsz, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy végrehajts egy %BARRELROLL% vagy %BOOST% akciót. Ha olyan akciót hajtottál végre, ami nincs az akciósávodon, elszenvedsz 1&nbsp;%HIT% sérülést."""
        "Swarm Tactics":
           display_name: """Swarm Tactics"""
           text: """Az ütközet fázis elején, kiválaszthatsz 1 baráti hajót 1-es távolságban. Ha így teszel, az a hajó a kör végéig kezelje úgy a kezdeményezés értékét, mintha egyenlő lenne a tiéddel."""
        "Tactical Officer":
           display_name: """Tactical Officer"""
           text: """<i>Kapott akció: %COORDINATE%</i>%LINEBREAK%<i>Követelmény: <r>%COORDINATE%</r></i>"""
        "Tactical Scrambler":
           display_name: """Tactical Scrambler"""
           text: """<i>csak közepes vagy nagy hajó</i>%LINEBREAK%Amikor akadályozod egy ellenséges hajó támadását, a védekező 1-gyel több védekezőkockával dob."""
        "Tobias Beckett":
           display_name: """Tobias Beckett"""
           text: """<i>csak Söpredék</i>%LINEBREAK%<strong>Felhelyezés:</strong> a hajók felhelyezése után, kiválaszthatsz 1 akadályt a pályáról. Ha így teszel, helyezd át bárhová 2-es távolságra a szélektől vagy hajóktól és 1-es távolságra más akadályoktól."""
        "Tractor Beam":
           display_name: """Tractor Beam"""
           text: """<strong>Támadás:</strong> ha a támadás talált, minden %HIT%/%CRIT% eredmény után sérülés helyett vonósugár jelzőt kap a védekező."""
        "Trajectory Simulator":
           display_name: """Trajectory Simulator"""
           text: """A Rendszer fázis alatt, ha ledobsz vagy kilősz egy bombát, kilőheted a [5&nbsp;%STRAIGHT%] sablonnal."""
        "Trick Shot":
           display_name: """Trick Shot"""
           text: """Amikor végrehajtasz egy támadást ami akadályozott egy akadály által, dobj 1-gyel több támadókockával."""
        "Unkar Plutt":
           display_name: """Unkar Plutt"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Miután részlegesen végrehajtasz egy manővert, elszenvedhetsz 1&nbsp;%HIT% sérülést, hogy végrehajts 1 fehér akciót."""
        "Veteran Tail Gunner":
           display_name: """Veteran Tail Gunner"""
           text: """<i>Követelmény: %REARARC%</i> %LINEBREAK%Miután végrehajtasz egy elsődleges %FRONTARC% támadást, végrehajthatsz egy bónusz elsődleges %REARARC% támadást."""
        "Veteran Turret Gunner":
           display_name: """Veteran Turret Gunner"""
           text: """<i>Követelmény: %ROTATEARC% vagy <r>%ROTATEARC%</r></i>%LINEBREAK%Amikor végrehajtasz egy elsődleges támadást, végrehajthatsz egy bónusz %SINGLETURRETARC% támadást egy olyan %SINGLETURRETARC% tűzívben, amiből még nem támadtál ebben a körben."""
        "Xg-1 Assault Configuration":
           display_name: """Xg-1 Assault Configuration"""
           text: """Amikor pontosan 1 'inaktív fegyverzet' jelződ van, akkor is végrehajthatsz %CANNON% támadást. Amikor %CANNON% támadást hajtasz végre 'inaktív fegyverzet' jelzővel, maximum 3 támadókockával dobhatsz.%LINEBREAK%Kapsz egy %CANNON% fejlesztés helyet."""
        "Zuckuss":
           display_name: """Zuckuss"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Amikor végrehajtasz egy támadást, ha nem vagy stresszes, válaszhatsz 1 védekezőkockát és kapsz 1 stressz jelzőt. Ha így teszel, a védekezőnek újra kell dobnia azt a kockát."""
        '"Chopper" (Crew)':
           display_name: """“Chopper”"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Az <strong>Akció végrehajtása</strong> lépés közben még stresszesen is végrehajthatsz 1 akciót. Miután stresszesen végrehajtasz egy akciót szenvedj el 1&nbsp;%HIT% sérülést vagy fordítsd fel 1 sérülés kártyád."""
        '"Chopper" (Astromech)':
           display_name: """“Chopper”"""
           text: """<i>csak Lázadók</i>%LINEBREAK%<strong>Akció:</strong> költs el 1 nem-újratölthető %CHARGE% jelzőt egy másik felszerelt fejlesztésről, hogy visszatölts 1 pajzsot%LINEBREAK%<strong>Akció:</strong> költs el 2 pajzsot, hogy visszatölts 1 nem-újratölthető %CHARGE% jelzőt egy felszerelt fejlesztésen."""
        '"Genius"':
           display_name: """“Genius”"""
           text: """<i>csak Söpredék</i>%LINEBREAK%Miután teljesen végrehajtasz egy manővert, ha még nem dobtál vagy lőttél ki eszközt ebben a körben, kidobhatsz 1 bombát."""
        '"Zeb" Orrelios':
           display_name: """“Zeb” Orrelios"""
           text: """<i>csak Lázadók</i>%LINEBREAK%Végrehajthatsz elsődleges támadást 0-ás távolságban. Az ellenséges hajók 0-ás távolságban végrehajthatnak elsődleges támadást ellened."""

        "Hardpoint: Cannon":
           text: """Kapsz egy %CANNON% fejlesztés helyet."""
        "Hardpoint: Missile":
           text: """Kapsz egy %MISSILE% fejlesztés helyet."""
        "Hardpoint: Torpedo":
           text: """Kapsz egy %TORPEDO% fejlesztés helyet."""
        "Black One":
           text: """<i>Kapott akció: %SLAM%</i> %LINEBREAK% Miután végrehajtasz egy %SLAM% akciót, elvesztesz 1&nbsp;%CHARGE% jelzőt. Ezután kaphatsz 1 ion jelzőt, hogy levedd az inaktív fegyverzet jelzőt. Ha a %CHARGE% nem aktív, nem hajthatsz végre %SLAM% akciót."""
        "Heroic":
           text: """<i>csak Ellenállás</i><br>Amikor védekezel vagy támadást hajtasz végre, ha 2 vagy több csak üres eredményed van, újradobhatsz akárhány kockát."""
        "Rose Tico":
           text: """Amikor védekezel vagy támadást hajtasz végre, elkölthetsz egy dobás eredményed, hogy bemérőt rakj az ellenséges hajóra."""
        "Finn":
           text: """Amikor védekezel vagy elsődleges támadást hajtasz végre,ha az ellenséges hajó a %FRONTARC% tűzívedben van, hozzáadhatsz 1 üres eredményt a dobásodhoz (ez a kocka újradobható vagy módosítható)."""
        "Integrated S-Foils":
           text: """<strong>Csukva: </strong><i>Kapott akció %BARRELROLL%, %FOCUS% &nbsp;<i class="xwing-miniatures-font xwing-miniatures-font-linked"></i>&nbsp;<r>%BARRELROLL%</r></i>%LINEBREAK% Amikor végrehajtasz egy elsődleges támadást, ha a védekező nincs a %BULLSEYEARC% tűzívedben, 1-gyel kevesebb támadókockával dobj. Mielőtt aktiválódsz, megfordíthatod ezt a kártyát.%LINEBREAK% <b>Nyitva:</b> Mielőtt aktiválódsz, megfordíthatod ezt a kártyát."""
        "Targeting Synchronizer":
           text: """<i>Követelmény: %LOCK%</i> %LINEBREAK% Amikor egy baráti hajó 1-2-es távolságban végrehajt egy támadást olyan célpont ellen, amit már bemértél, az a hajó figyelmen kívül hagyhatja a %LOCK% támadási követelményt."""
        "Primed Thrusters":
           text: """<i>csak kis hajó</i> %LINEBREAK%Amikor 2 vagy kevesebb stressz jelződ van, végrehajthatsz %BARRELROLL% és %BOOST% akciót még ha stresszes is vagy."""
        "Kylo Ren":
           text: """<strong>Akció: </strong> Válassz 1 ellenséges hajót 1-3-as távolságban. Ha így teszel, költs el 1&nbsp;%FORCE% jelzőt, hogy hozzárendeled az <strong>I'll Show You the Dark Side</strong> kondíciós kártyát a kiválasztott hajóhoz."""
        "General Hux":
           text: """Amikor végrehajtasz egy fehér %COORDINATE% akciót, kezelheted pirosként. Ha így teszel, koordinálhatsz további 2 azonos típusú hajót, mindegyikét azonos akcióval és pirosként kezelve."""
        "Fanatical":
           text: """Amikor végrehajtasz egy elsődleges támadást, ha nincs pajzsod, megváltoztathatsz 1&nbsp;%FOCUS% eredményt %HIT% eredményre."""
        "Special Forces Gunner":
           text: """Amikor végrehajtasz egy elsődleges %FRONTARC% támadást, ha a %SINGLETURRETARC% tűzíved a %FRONTARC% tűzívedben van, 1-gyel több kockával dobhatsz. Miután végrehajtasz egy elsődleges %FRONTARC% támadást, ha a %SINGLETURRETARC% tűzíved a %REARARC% tűzívedben van, végrehajthatsz egy bónusz elsődleges %SINGLETURRETARC% támadást."""
        "Captain Phasma":
           text: """Az Ütközet fázis végén, minden 0-1 távolságban lévő ellenséges hajó ami nem stresszes, kap 1 stressz jelzőt."""
        "Supreme Leader Snoke":
           text: """A Rendszer fázis alatt kiválaszthatsz bármennyi hajót 1-es távolságon túl. Ha így teszel költs el annyi %FORCE% jelzőt, amennyi hajót kiválasztottál, hogy felfordítsd a tárcsájukat."""
        "Hyperspace Tracking Data":
           text: """<strong>Felhelyezés:</strong> a hajó felhelyezés előtt válassz egy számot 0 és 6 között. Kezeld a Initiative-od a kiválasztott számnak megfelelően. A felhelyezés után rendelj hozzá 1&nbsp;%FOCUS% vagy %EVADE% jelzőt minden baráti hajóra 0-2-es távolságban."""
        "Advanced Optics":
           text: """Amikor támadást hajtasz végre, elkölthetsz 1&nbsp;%FOCUS% jelzőt, hogy 1 üres eredményed %HIT% eredményre változtass."""
        "Rey":
           text: """Amikor védekezel vagy támadást hajtasz végre, ha az ellenséges hajó benne van a %FRONTARC% tűzívedben, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy 1 üres eredményed %EVADE% vagy %HIT% eredményre változtass."""
        "Chewbacca (Resistance)":
           text: """<strong>Felhelyezés:</strong>: elvesztesz el 1&nbsp;%CHARGE% jelzőt. %LINEBREAK% Miután egy baráti hajó 0-3-as távolságban felhúz 1 sérülés kártyát, állítsd helyre 1&nbsp;%CHARGE% jelzőt. Amikor támadást hajtasz végre elkölthetsz 2&nbsp;%CHARGE% jelzőt, hogy 1&nbsp;%FOCUS% eredményed %CRIT% eredményre változtass."""
        "Paige Tico":
           text: """Miután véggrehajtasz egy elsődleges támadást, ledobhatsz egy bombát vagy forgathatod a %SINGLETURRETARC% tűzívedet. Miután megsemmisültél ledobhatsz 1 bombát."""
        "R2-HA":
           text: """Amikor védekezel, elköltheted a támadón lévő bemérődet, hogy újradobd bármennyi védőkockádat."""
        "C-3PO (Resistance)":
           text: """ <i>Kapott akció: %CALCULATE% <r>%COORDINATE%</r></i> %LINEBREAK% Amikor koordinálsz, választhatsz baráti hajót 2-es távolságon túl, ha annak van %CALCULATE% akciója. Miután végrehajtod a %CALCULATE% vagy %COORDINATE% akciót, kapsz 1&nbsp;%CALCULATE% jelzőt."""
        "Han Solo (Resistance)":
           text: """ <i>Kapott akció: <r>%EVADE%</r></i> %LINEBREAK%Miután végrehajtasz egy %EVADE% akciót, annyival több %EVADE% jelzőt kapsz, ahány ellenséges hajó van 0-1-es távolságban."""
        "Rey's Millennium Falcon":
           text: """Ha 2 vagy kevesebb stressz jelződ van, végrehajthatsz piros Segnor Csavar manővert [%SLOOPLEFT% vagy %SLOOPRIGHT%] és végrehajthatsz %BOOST% és %ROTATEARC% akciókat, még ha stresszes is vagy."""
        "Petty Officer Thanisson":
           text: """Az Aktivációs vagy Ütközet fázis közben, miután egy ellenséges hajó a %FRONTARC% tűzívedben 0-1-es távolságban kap egy piros vagy narancs jelzőt, ha nem vagy stresszes, kaphatsz egy stressz jelzőt. Ha így teszel, az a hajó kap még egy jelzőt abból, amit kapott."""
        "BB-8":
           text: """Mielőtt végrehajtasz egy kék manővert, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy végrehajts egy %BARRELROLL% vagy %BOOST% akciót."""
        "BB Astromech":
           text: """Mielőtt végrehajtasz egy kék manővert, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy végrehajts egy %BARRELROLL% akciót."""
        "M9-G8":
           text: """Amikor egy hajó amit bemértél végrehajt egy támadást, kiválaszthatsz egy támadókockát. Ha így teszel, a támadó újradobja azt a kockát."""
        "Ferrosphere Paint":
           text: """Miután egy ellenséges hajó bemért téged, ha nem vagy annak a hajónak a %BULLSEYEARC% tűzívében, az kap egy stressz jelzőt."""
        "Brilliant Evasion":
           text: """Amikor védekezel, ha nem vagy a támadó %BULLSEYEARC% tűzívében, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy 2&nbsp;%FOCUS% eredményed %EVADE% eredményre változtass."""
        "Calibrated Laser Targeting":
           text: """Amikor végrehajtasz egy elsődleges támadást, ha a védekező benne van a %BULLSEYEARC% tűzívedben, adj a dobásodhoz 1&nbsp;%FOCUS% eredményt."""
        "Delta-7B":
           text: """ <i>Kapott : 1 támadási érték, 2 pajzs %LINEBREAK% Elveszett: 1 védekezés</i> """
        "Biohexacrypt Codes":
           text: """Amikor koordinálsz vagy zavarsz, ha van bemérőd egy hajón, elköltheted azt a bemérőt, hogy a távolság követelményeket figyelmen kívül hagyd a hajó kiválasztákor."""
        "Predictive Shot":
           text: """Miután támadásra jelölsz egy célpontot, ha a védekező benne van a %BULLSEYEARC% tűzívedben, elkölthetsz 1&nbsp;%FORCE% jelzőt. Ha így teszel, a védekező a <strong>Védekezőkockák dobása</strong> lépésben nem dobhat több kockával, mint a %HIT%/%CRIT% eredményeid száma."""
        "Hate":
           text: """Miután elszenvedsz 1 vagy több sérülést, feltölthetsz ugyanannyi %FORCE% jelzőt."""
        "R5-X3":
           text: """Mielőtt aktiválódsz vagy rád kerül a sor az Ütközet fázisban, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy figyelmen kívül hagyd az akadályokat annak a fázisnak a végéig."""
        "Pattern Analyzer":
           text: """Amikor teljesen végrehajtasz egy piros manővert, a <strong>Nehézség ellenőrzése</strong> lépés előtt végrehjathatsz 1 akciót."""
        "Impervium Plating":
           text: """Mielőtt egy felfordított <b>Ship</b> sérüléskártyát kapnál, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy eldobd."""
        "Grappling Struts":
           text: """<strong>Csukva: </strong> Felhelyezés: ezzel az oldalával helyezd fel. %LINEBREAK% Amikor végrehajtasz egy manővert, ha átfedésbe kerülsz egy aszteroidával vagy űrszeméttel és 1 vagy kevesebb másik baráti hajó van 0-ás távolságra attól az akadálytól, megfordíthatod ezt a kártyát. 
		   %LINEBREAK% <b>Nyitva:</b> Hagyd figyelment kívül a 0-ás távolságnban lévő akadályokat amíg átmozogsz rajtuk. Miután felfeded a tárcsádat, ha más manővert fedtél fel mint [2 %STRAIGHT%] és 0-ás távolságra vagy egy aszteroidától vagy űrszeméttől, ugord át a 'Manőver végrehajtása' lépést és vegyél le 1 stresst jelzőt; ha jobb vagy bal manővert fedtél fel, forgasd a hajódat 90 fokkal abba az irányba. Miután végrehajtasz egy manővert fordítsd át ezt a kártyát."""
        "Energy-Shell Charges":
           text: """ <strong>Támadás (%CALCULATE%):</strong> Költs el 1&nbsp;%CHARGE% jelzőt. Amikor végrehajtasz egy támadást, elkölthetsz 1&nbsp;%CALCULATE% jelzőt, hogy megváltoztass 1&nbsp;%FOCUS% eredményt %CRIT% eredményre.%LINEBREAK% <strong>Akció:</strong> Töltsd újra ezt a kártyát."""
        "Dedicated":
           text: """Amikor egy másik baráti hajó a %LEFTARC% vagy a %RIGHTARC% tűzívedben 0-2-es távolságban védekezik, ha az limitált vagy Dedicated fejlesztéssel felszerelt és nem vagy túlterhelve, kaphatsz 1 túlterhelés jelzőt. Ha így teszel a védekező újradobhatja 1 üres eredményét."""
        "Synchronized Console":
           text: """Miután végrehajtasz egy támadást, választhatsz egy baráti hajót 1-es távolságban vagy egy baráti hajót 'Synchronized Console' fejlesztéssel 1-3 távolságban és költsd el a védekezőn lévő bemérődet. Ha így teszel, a kiválasztott baráti hajó kaphat egy bemérőt a védekezőre."""
        "Battle Meditation":
           text: """Nem koordinálhatsz limitált hajót.%LINEBREAK%Amikor végrehajtasz egy lila %COORDINATE% akciót, koordinálhatsz 1 további ugyanolyan típusú nem limitált baráti hajót. Mindkét hajónak ugyanazt az akciót kell végrehajtania."""
        "R4-P Astromech":
           text: """Mielőtt végrehajtasz egy alapmanővert, elkölthetsz 1&nbsp;%CHARGE% jelzőt. Ha így teszel, a manőver végrehajtása közben csökkentsd annak nehézségét."""
        "R4-P17":
           text: """Miután teljesen végrehajtasz egy piros manővert, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy végrehajts egy akciót, még ha stresses is vagy."""
        "Spare Parts Canisters":
           text: """Akció: költs el 1&nbsp;%CHARGE% jelzőt, hogy visszatölts 1&nbsp;%CHARGE% jelzőt egy felszerelt %ASTROMECH% fejlesztéseden.%LINEBREAK%
		   Akció: költs el 1&nbsp;%CHARGE% jelzőt, hogy kidobj 1 tartalék alkatrész jelzőt, aztán vegyél le minden rajtad lévő bemérőt."""
        "Scimitar":
           text: """Felhelyezés: a hajók felhelyezése After the Place Forces step, you may cloak. %LINEBREAK% After you decloak, you may choose an enemy ship in your %BULLSEYEARC%. If you do, it gains 1 jam token."""
        "Chancellor Palpatine":
           text: """<strong>Felhelyezés:</strong> Ezzel az oldalával szereld fel.%LINEBREAK% Miután védekeztél, ha a támadó 0-2-es távolságban van, elkölthetsz 1&nbsp;%FORCE% jelzőt. Ha így teszel, a támadó kap egy stressz jelzőt.%LINEBREAK% A vége fázisban megfordíthatod ezt a kártyát.%LINEBREAK% <strong>Darth Sidious:</strong> Miután végrehajtasz egy lila %COORDINATE% akciót, a koordinált hajó kap 1 stressz jelzőt, majd kap 1&nbsp;%FOCUS% jelzőt vagy visszatölt 1&nbsp;%FORCE% jelzőt."""
        "Count Dooku":
           text: """Mielőtt egy hajó 0-2-es távolságban támadó vagy védekező kockákat gurít, ha minden %FORCE% jelződ aktív, elkölthetsz 1&nbsp;%FORCE% jelzőt, hogy megnevezz egy eredményt. Ha a dobás nem tartalmazza megnevezett eredményt, a hajónak meg kell változtatni 1 kockáját arra az eredményre."""
        "General Grievous":
           text: """Amikor védekezel, az 'Eredmények semlegesítése' lépés után, ha 2 vagy több %HIT%/%CRIT% eredmény van, elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy semlegesíts 1 %HIT% vagy %CRIT% eredményt.%LINEBREAK%Miután egy baráti hajó megsemmisül, tölts vissza 1&nbsp;%CHARGE% jelzőt."""
        "K2-B4":
           text: """Amikor egy baráti hajó 0-3-as távolságban védekezik, elkölthet 1 %CALCULATE% jelzőt. Ha így tesz, adjon 1 %EVADE% eredményt a dobásához, hacsak a támadó nem tönt úgy, hogy kap 1 túlterhelés jelzőt."""
        "DRK-1 Probe Droids":
           text: """A Vége fázis alatt elkölthetsz 1&nbsp;%CHARGE% jelzőt, hogy kidobj vagy kilőj 1 DRK-1 kutaszdroidot egy 3-as sebességű sablon segítségével.%LINEBREAK%E a kártya %CHARGE% jelzője nem visszatölthető."""
        "Kraken":
           text: """A Vége fázis alatt kiválaszthatsz akár 3 baráti hajót 0-3-as távolságban. Ha így teszel, ezen hajók nem dobják el 1 %CALCULATE% jelzőjüket."""
        "TV-94":
           text: """Amikor egy baráti hajó 0-3-as távolságban végrehajt egy elsődleges támadást egy a %BULLSEYEARC% tűzívében lévő védekező ellen, ha 2 vagy kevesebb a támadó kockák száma, elkölthet 1 %CALCULATE% jelzőt, hogy hozzáadjon a dobásához 1 %HIT% eredményt."""
        "Discord Missiles":
           text: """Az Ütközet fázis elején elkölthetsz 1 %CALCULATE% jelzőt és 1 %CHARGE% jelzőt, hogy kilőj 1 'buzz droid swarm' jelzőt a [3 %BANKLEFT%], [3 %STRAIGHT%] vagy [3 %BANKRIGHT%] használatával. Ennek a kártyának a %CHARGE% jelzője nem tölthető újra."""
        "Clone Commander Cody":
           text: """Miután végrehajtasz egy támadást ami nem talált, ha 1 vagy több %HIT%/%CRIT% eredményt lett semlegesítve, a védekező kap 1 túlterhelés jelzőt."""
        "Seventh Fleet Gunner":
           text: """Amikor egy másik baráti hajó végrehajt egy elsődleges támadást, ha a védekező a tűzívedben van, elkölthetsz 1 %CHARGE% jelzőt. Ha így teszel a támadó 1-gyel több kockával dob, de maximum 4-gyel. A rendszer fázisban kaphatsz 1 'inaktív fegyverzet' jelzőt, hogy visszatölts 1&nbsp;%CHARGE% jelzőt."""
        "R4-P44":
           text: """Miután teljesen véggrehajtasz egy piros manővert, ha van egy ellenséges hajó a %BULLSEYEARC% tűzívedben, kapsz 1 %CALCULATE% jelzőt."""
        "Treacherous":
           text: """Amikor védekezel, kiválaszthatsz egy a támadást akadályozó hajót és költs el 1 %CHARGE% jelzőt. Ha így teszel, semlegesíts 1 %HIT% vagy %CRIT% eredményt és a kiválasztott hajó kap egy túlterhelés jelzőt. Ha egy hajó 0-3-as távolságban megsemmisül, tölts vissza 1 %CHARGE% jelzőt."""
        "Soulless One":
           text: """Amikor védekezel, ha a támadó a tűzíveden kívül van újradobhatsz 1 védekezőkockát."""
        
    condition_translations =
        'Suppressive Fire':
           text: '''Amikor végrehajtasz egy támadást más hajó ellen mint <strong>Captain Rex</strong>, dobj 1-gyel kevesebb kockával.%LINEBREAK% Miután <strong>Captain Rex</strong> védekezik, vedd le ezt a kártyát. %LINEBREAK% Az Ütközet fázis végén, ha <strong>Captain Rex</strong> nem hajtott végre támadást ebben a fázisban, vedd le ezt a kártyát. %LINEBREAK% Miután <strong>Captain Rex</strong> megsemmisült, vedd le ezt a kártyát.'''
        'Hunted':
           text: '''Miután megsemmisültél, választanod kell egy baráti hajót és átadni neki ezt a kondíció kártyát.'''
        'Listening Device':
           text: '''A Rendszer fázisban, ha egy ellenséges hajó az <strong>Informant</strong> fejlesztéssel 0-2-es távolságban van, fedd fel a tárcsád.'''
        'Rattled':
           text: '''Miután egy bomba vagy akna 0-1-es távolságban felrobban, elszenvedsz 1 %CRIT% sérülést. Aztán vedd le ezt a kártyát.%LINEBREAK%<strong>Akció:</strong> Ha nincs bomba vagy akna 0-1-es távolságban, vedd ele ezt a kártyát.'''
        'Optimized Prototype':
           text: '''Amikor végrehajtasz egy elsődleges %FRONTARC% támadást egy olyan hajó ellen, amit bemért <strong>Director Krennic</strong> fejlesztéssel felszerelt hajó, elkölthetsz 1&nbsp;%HIT%/%CRIT%/%FOCUS% eredményt. Ha így teszel, választhatsz, hogy a védekező elveszt 1 pajzsot vagy a védekező felfordítja 1 sérüléskártyáját.'''
        '''I'll Show You the Dark Side''': 
           text: '''Mikor ezt a kártyát hozzárendelik egy hajódhoz, ha nincs felfordított sérüléskártya rajta, az ellenfél kikeres a sérüléskártyáidból egy pilóta típusút és felfordítva ráteszi. Aztán megkeveri a paklit. Amikor elszenvednél 1&nbsp;%CRIT% sérülést, ezen a kártyán lévő sérüléskártyát kapod meg. Aztán vedd le ezt a lapot.'''
        'Proton Bomb':
           text: '''(Bomba jelző) - Az Aktivációs fázis végén ez az eszköz felrobban. Amikor ez az eszköz felrobban, minden hajó és távérzékelő 0–1-es távolságban elszenved 1&nbsp;%CRIT% sérülést.'''
        'Seismic Charge':
           text: '''(Bomba jelző) - Az Aktivációs fázis végén ez az eszköz felrobban. Amikor ez az eszköz felrobban, válassz 1 akadály 0–1-es távolságban. Minden hajó és távérzékelő 0–1-es távolságra az akadálytól elszenved 1&nbsp;%HIT% sérülést.'''
        'Bomblet':
           text: '''(Bomba jelző) - Az Aktivációs fázis végén ez az eszköz felrobban. Amikor ez az eszköz felrobban, minden hajó 0–1-es távolságban dob 2 támadókockával. Minden hajó és távérzékelő elszenved 1&nbsp;%HIT% sérülést minden egyes %HIT%/%CRIT% eredmény után.'''
        'Loose Cargo':
           text: '''(Űrszemét jelző) - A kidobott rakomány űrszemétnek számít.'''
        'Conner Net':
           text: '''(Akna jelző) - Miután egy hajó átmozog vagy átfedésbe kerül ezzel az eszközzel, az felrobban. Amikor ez az eszköz felrobban, a hajó elszenved 1&nbsp;%HIT% sérülést és kap 3 ion jelzőt.'''
        'Proximity Mine':
           text: '''(Akna jelző) - Miután egy hajó átmozog vagy átfedésbe kerül ezzel az eszközzel, az felrobban. Amikor ez az eszköz felrobban, a hajó dob 2 támadókockával, aztán elszenved 1&nbsp;%HIT%, valamint a dobott eremény szerint 1-1 %HIT%/%CRIT% sérülést.'''
        'DRK-1 Probe Droid':
           text: '''INIT: 0 / MOZGÉKONYSÁG: 3 / HULL: 1 / (távérzékelő)%LINEBREAK%Amikor egy baráti hajó bemér egy objektumot vagy zavar egy ellenséges hajót, mérheti a távolságot tőled. Miután egy ellenséges hajó átfedésbe kerül veled, az dob egy támadókockával. %FOCUS% eredménynél elszenvedsz 1 %HIT% sérülést.%LINEBREAK%Rendszer fázis: a kezdeményezésednek megfelelően arrébb mozgathatod a [2 %BANKLEFT%], [2 %STRAIGHT%] vagy [2 %BANKRIGHT%] sablonnal.'''
        'Buzz Droid Swarm':
           text: '''INIT: 0 / MOZGÉKONYSÁG: 3 / HULL: 1 / (távérzékelő)%LINEBREAK%Miután egy ellenséges hajó átmozog rajtad vagy átfedésbe kerül veled, átteheted annak első vagy hátsó pöckeihez (ilyenkor 0-ás távolságra vagy a hajótól). Nem lehetsz átfedésbe egy objektummal sem ily módon. Ha nem tudod elhelyezni a pöckökhöz, te és a hajó is elszenvedtek 1 %HIT% sérülést.%LINEBREAK%Ütközet fázis: a kezdeményezésednek megfelelően minden 0-ás távolságba nlévő hajó elszenved 1 %CRIT% sérülést.'''
            
    exportObj.setupTranslationCardData pilot_translations, upgrade_translations, condition_translations
