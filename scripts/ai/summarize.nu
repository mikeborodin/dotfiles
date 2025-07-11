#! env nu

def main [file:string] {
  
  if ($file | path exists) {
     
    print $in
    if ( ($file | path type) == 'dir' ) {
        let summary = tree -L 5 $file | aichat -S -s -m ollama:qwen3:1.7b ' TASK: summarize this information with 5 bullet points, output YAML'
        
        let name = $"($file).sum.md"

        $summary | save -f $name

        print $"saved ($name)"

    } else {
        let summary = open --raw $file | aichat -S -s -m ollama:qwen3:1.7b ' TASK: summarize this information with 5 bullet points, output YAML'
        
        let name = $"($file).sum.md"

        $summary | save -f $name

        print $"saved ($name)"
    }
  }
}
