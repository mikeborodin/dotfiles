set -e

cd /Users/mike/personal_projects/piper

dart run  --define=AZURE_TOKEN=$AZURE_TOKEN  cli/bin/piper_cli.dart watch
# echo "$pipelines T:$(date +'%I:%M')"
