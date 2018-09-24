import argparse
import json
import requests

# A list of all languages (can be expanded)
languages = ['de', 'en', 'fr', 'es', 'it', 'pl', 'pt']

# The user can decide whether to download all JSON files or to select one
# language.
parser = argparse.ArgumentParser(description='Download the JSON files from the\
                                 squadbuilder API. Output file will always be\
                                 [prefix]_[language].json.')
parser.add_argument('language', type=str, choices=languages + ['all'],
                    help='The desired language in country language code. You\
                    can download all languages at once with \'all\'.')
parser.add_argument('--prefix', '-p', type=str, default='api_export_',
                    help='Prefix of the file name. Defaults to \'api_export_\'.')

# Sets the language to the desired language
args = parser.parse_args()
if args.language == 'all':
    languages = languages
else:
    languages = [args.language]

# File prefix set according to arguments
prefix = args.prefix

# url = 'http://localhost/api_export_de.json'
url = 'https://squadbuilder.fantasyflightgames.com/api/cards/'

# The API doesn't like python scripts, so we fool into thinking we're a browser
headers = {'User-Agent': 'Mozilla/4.0'}

# We receive one JSON in every language
for lang in languages:
    print("Processing language: " + lang + "...")
    filename = prefix + lang + '.json'
    headers.update({'Accept-Language': lang})

    print('Downloading file from ' + url + '...')
    # Download the file from `url` and save it locally under `file_name`:
    with requests.get(url, headers) as response, open(filename, 'w') as outfile:
        print('Processing JSON file...')

        # We make the file more readable before saving it.
        obj = response.json()
        json.dump(obj, outfile, sort_keys=True, indent=4)
        print("Wrote to " + filename + ".")
