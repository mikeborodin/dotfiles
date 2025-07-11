#! env nu

def main [file:string] {
  print "working..."
  nu ~/personal_projects/dotfiles/scripts/ai/rewrite_file.nu instruction/refactor.md $file

  while ( (flutter analyze | complete | get exit_code) != 0 ) {
    print "retrying..."
    nu ~/personal_projects/dotfiles/scripts/ai/rewrite_file.nu instruction/refactor.md $file
  } 

  print "applying"

  # mv $"($file).wip.dart" $file
}
