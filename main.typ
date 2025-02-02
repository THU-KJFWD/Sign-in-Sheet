#set text(font: "Source Han Serif SC")

#import "src/lib.typ": generate_sheets

#let data = json("data.json")

#generate_sheets(
  data.members,
  max_members: 8 // 希望表格一共有多少行
)
