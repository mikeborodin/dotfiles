#! env nu

def main [instruction: string,file:string] {
  
  if ($file | path exists) {
    let type = ($file | path type)
    if ( $type == 'file' ) {

        const self = path self

        let task = open ([($self | path dirname), $instruction] | path join)

        let dirname = $file | path dirname

        # let content = aichat -m ollama:llama3.2:latest -S -f $file $task  | extract
        let content = aichat -r %functions% --session $"refactoring_($file)" -S -f $file -f $dirname  $"We will work only with file ($file), in response please provide the content for ($file). ($task)" | extract
        let tmpFile = $"($file).wip.dart"
        $content | save -f $tmpFile

        while ( (flutter analyze $tmpFile | complete | get exit_code) != 0 ) {
         print "retrying..."

         let content = aichat -r %functions% --session $"refactoring_($file)" -S -f $file -f $dirname  $"We will work only with file ($file). ($task)" | extract
         let tmpFile = $"($file).wip.dart"
         $content | save -f $tmpFile
        } 

        print $"done"
        mv $tmpFile $file
    } else {
        print $"not a file but ($type)"
    }
  } else {
        print $"file does not exist"
  }
}
