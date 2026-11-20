def adf:
  if type == "string" then .
  elif type != "object" then ""
  else
    (.content // [] | map(adf)) as $c
    | if .type == "text" then
        (.marks // [] | map(.type)) as $m
        | if ($m | index("code")) then "`\(.text)`"
          elif ($m | index("link")) then "[\(.text)](\(.marks[] | select(.type == "link") | .attrs.href))"
          else .text end
      elif .type == "hardBreak" then "\n"
      elif .type == "mention" then .attrs.text // "@user"
      elif .type == "emoji" then .attrs.text // .attrs.shortName // ""
      elif .type == "status" then "[\(.attrs.text)]"
      elif .type == "date" then .attrs.timestamp | tonumber / 1000 | strftime("%Y-%m-%d")
      elif .type == "media" then "[attachment]"
      elif .type == "mediaSingle" or .type == "mediaGroup" then ($c | join(" ")) + "\n\n"
      elif .type == "inlineCard" or .type == "blockCard" then .attrs.url // ""
      elif .type == "paragraph" then ($c | join("")) + "\n\n"
      elif .type == "heading" then ("#" * ((.attrs.level // 1) + 2)) + " " + ($c | join("")) + "\n\n"
      elif .type == "codeBlock" then "```\(.attrs.language // "")\n\($c | join(""))\n```\n\n"
      elif .type == "rule" then "---\n\n"
      elif .type == "bulletList" or .type == "orderedList" or .type == "taskList" then
        (.type) as $t
        | [.content[] | adf | rtrimstr("\n") | split("\n") | map(select(. != ""))
            | (if $t == "orderedList" then "1. " elif $t == "taskList" then "- [ ] " else "- " end) + .[0]
              + (.[1:] | map("\n  " + .) | join(""))]
        | join("\n") + "\n\n"
      elif .type == "listItem" or .type == "taskItem" then $c | join("")
      elif .type == "tableRow" then "| " + ($c | map(rtrimstr("\n\n") | gsub("\n+"; " ")) | join(" | ")) + " |\n"
      elif .type == "table" then ($c | join("")) + "\n"
      else $c | join("") end
  end;
def text: if type == "object" and .type == "doc" then adf | sub("\\s+$"; "") else . end;
def textlike: type == "string" or (type == "object" and .type == "doc");

.fields as $f
| "# \(.key): \($f.summary)",
  "",
  "- Type: \($f.issuetype.name // "-")",
  "- Status: \($f.status.name // "-")",
  "- Priority: \($f.priority.name // "-")",
  (if $f.parent then "- Parent: \($f.parent.key): \($f.parent.fields.summary)" else empty end),
  (if ($f.labels // []) != [] then "- Labels: \($f.labels | join(", "))" else empty end),
  (if ($f.components // []) != [] then "- Components: \($f.components | map(.name) | join(", "))" else empty end),
  (if ($f.issuelinks // []) != [] then
    "- Links: " + ($f.issuelinks | map(
      if .outwardIssue then "\(.type.outward) \(.outwardIssue.key) (\(.outwardIssue.fields.summary))"
      else "\(.type.inward) \(.inwardIssue.key) (\(.inwardIssue.fields.summary))" end) | join("; "))
  else empty end),
  "",
  "## Description",
  "",
  ($f.description // "(none)" | text),
  ($f | to_entries[]
    | select((.key | startswith("customfield_")) and (.value | textlike) and (.value | text | test("\\S\\s+\\S")))
    | "", "## \(.key)", "", (.value | text)),
  (if ($f.subtasks // []) != [] then
    "", "## Subtasks", "", ($f.subtasks[] | "- \(.key) [\(.fields.status.name)]: \(.fields.summary)")
  else empty end),
  (if ($f.comment.comments // []) != [] then
    "", "## Comments",
    ($f.comment.comments[] | "", "### \(.author.displayName) (\(.created[:10]))", "", (.body | text))
  else empty end)
