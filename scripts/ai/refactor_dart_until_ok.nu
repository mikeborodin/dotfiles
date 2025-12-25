#! env nu

def main [file:string] {
  print "working..."
  let git_root = (git rev-parse --show-toplevel | str trim)
  nu ($git_root | path join 'scripts/ai/rewrite_file.nu') instruction/refactor.md $file

  while ( (flutter analyze | complete | get exit_code) != 0 ) {
    print "retrying..."
    nu ($git_root | path join 'scripts/ai/rewrite_file.nu') instruction/refactor.md $file
  } 

  print "applying"

  # mv $"($file).wip.dart" $file
}
