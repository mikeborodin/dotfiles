contents() {
    echo
    echo $1:
    fileExtension=$(echo $1 | cut -d'.' -f2)

    echo "\`\`\`$fileExtension
$(cat $1)
\`\`\`"
}

diagnostics_context() {
    echo """
There are issues in the file reported by dart analyze:
"""
    dart analyze

    echo """
Current contents of the file:
"""
    contents $1

    echo """
Please try to fix the issues and return the fixed code  snippet.
"""
}

project_context() {
    contents project_context.md
}

ai_task_in_context() {
    prompt=$1
    file=$2

    project_context

    if [ -n "$file" ]; then
        contents $file
    fi

    echo $prompt
}

ai_implement_in_context() {
}

ai_update_implementation() {
    echo """
Write enough implementation to pass these Dart tests so that we get to Green step of TDD.
"""
    project_context

    echo """
The following file contains the updated unit tests:
"""

    contents $1

    echo """
The following file contains already existing implementation which needs to be updated to pass all the unit tests:
"""

    implFile=$(other $1)
    contents $implFile

    echo "Update implementation to pass the tests above."
}

implement_given_output() {
    ai_implement_in_context $1
    echo """
Current output of the 'dart test' command:
"""
    dart test $1

    echo """
Implement code given the following test and their output
"""
}

ai_task_in_context() {
    prompt="""
  Context:
  $1 

  Your task:
  $2
  """
    echo $prompt | coder
}

# something not parsing?
# function get_first_words() {
#     while IFS=' ' read -r line; do
#         echo "$line" | cut -f1
#     done
# }

function selectOllamaModel() {
    exp=$(ollama list | get_first_words | fzf | xargs -I {} echo "export OLLAMA_MODEL={}")
    eval $exp
}

function model_task_in_context() {
    model=${OLLAMA_MODEL:-mistral}
    prompt="""
  Context:
  $1 

  Your task:
  $2
  """

    echo $prompt | ollama run $model
}

# Spec approach
ai_task_in_context_spec() {
    ai_task_in_context "$(contents $1)" "create bullet-point list of the expected behavior of the class under test here, keep it simple, refer to the class by its name"
}

ai_task_in_context_spec2() {
    ai_task_in_context "$(contents $1)" """
 Create bullet point list of requirements for code under tests based on these tests"""
}

ai_task_in_context_spec3() {
    model_task_in_context """
 $(project_context)
 $(contents $1)

 """ "create bullet point list of requirements for code under tests based tests in $1"
}

ai_task_in_context_spec4() {
    model_task_in_context """
 $(project_context)
 $(contents $1)

 """ "create bullet point list of requirements for code under tests based tests in $(other $1), refer to it as 'code'"
}

ai_task_criticize() {
    model_task_in_context """
 $(project_context)
 $(contents $1)

 Your role: Senior developer reviewing the pull request.
 """
    "criticize code in $1"
}

ai_task_duplications() {
    model_task_in_context """
 $(project_context)
 $(contents $1)

 Your role: Senior developer reviewing the pull request.
 """
    "try to find duplicated snippets of code in $1"
}

ai_task_logic_flaws() {
    model_task_in_context """
 $(project_context)
 $(contents $1)

 Your role: Senior developer reviewing the pull request.
 """
    "try to find logical inconsistencies $1"
}

ai_task_implement_spec() {
    specification=$(ai_task_in_context_spec $1)
    echo $specification
    ai_task_in_context "$specification" "Based on this spec generate implementation in Dart, keep it simple."
}

ai_task_implement_spec2() {
    specification=$(ai_task_in_context_spec2 $1)
    echo $specification
    ai_task_in_context "$specification" "Based on the specification generate code in Dart (no tests or explanations please)"
}

ai_task_implement_spec3() {
    specification=$(ai_task_in_context_spec3 $1)

    echo $specification

    model_task_in_context """
$(project_context)

Specification:
$spec

""" "based on the Specification above generate code in Dart (no tests or explanations please):"
}

ai_task_implement_spec4() {
    specification=$(ai_task_in_context_spec4 $1)

    echo $specification

    model_task_in_context """
$(project_context)

Specification:
$specification

""" "based on the Specification above generate code in Dart (no tests or explanations please):"
}

ai_task_implement_direct_in_context() {
    model_task_in_context """
$(project_context)

Tests:
    $(contents $1)
"""
    "implement code sufficient to pass the tests above, excude any include any tests"

}

ai_task_implement_direct() {
    model_task_in_context """
Unit tests file:
$(contents $1)
""" "implement code sufficient to pass the tests above, excude any include any tests"
}

ai_implement_all() {
    ai_implement_in_context $1 | coder | extract | tee $(other $1)
}
ai_implement_update_all() {
    ai_implement_in_context $1 | coder | extract | tee $(other $1)
}
