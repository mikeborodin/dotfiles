#! env nu

def main [file:string] {
  
  if ($file | path exists) {
     
    print $in
    if ( ($file | path type) == 'dir' ) {
      tree -L 5 $file | ai 
    } else {
        print "running"
        open --raw $file
        let summary = open --raw $file | aichat -S -s -m ollama:qwen3:1.7b ' TASK: summarize this information with 5 bullet points, output YAML'
        
        let name = $"($file).sum"

        print "saving"
        $summary | save -f $name
    }
  }
}
