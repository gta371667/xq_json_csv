A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

## csv_to_i18n
csv -i ./assets/web_0930_gogo.csv -o ./assets/i18n/

## json_to_csv
translate -i ./assets/i18n/ -o ./assets/out_i18n_app.csv

## merge
merge -f ./assets/web_back.csv -b ./assets/origin/total.csv -o ./assets/merge.csv

## single
translate -i ./assets/test/merge0725.json -o ./assets/out0725.csv 
