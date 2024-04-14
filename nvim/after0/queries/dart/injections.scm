((comment) @injection.content
  (#set! injection.language "graphql"))

(static_final_declaration 
    left: (identifier) @_id
    right: (string (string_content) @injection.content)
    (#match? @_id "_storesQuery")
    (#set! injection.language "graphql"))

