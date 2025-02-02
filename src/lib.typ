#import "@preview/tablex:0.0.9": hlinex, vlinex, tablex

#let sheet(
  title: "科技服务分队C楼岗签到表",
  weekday: 1,
  members: none,
  max_members: none
) = {
  set text(lang: "zh", region: "cn")

  set page(paper: "a4", margin: (x: 10%, y: 10%, top: 8%, bottom: 8%))

  let num_to_chinese(id) = {
         if id == 1 { "一" }
    else if id == 2 { "二" }
    else if id == 3 { "三" }
    else if id == 4 { "四" }
    else if id == 5 { "五" }
    else if id == 6 { "六" }
    else if id == 7 { "日" }
    else            { "?"  };
  }

  set align(left)

  box(baseline: 0%, width: 60%)[
    #align(left, [
      #set text(size: 2em)
      #set par()
      *#title*
    ])
  ]

  box(baseline: 60%, width: 40%)[
    #align(right, smallcaps[
      #set text(size: 4em)
      #box("周" + num_to_chinese(weekday), stroke: 1.5pt, inset: 8pt, baseline:0%)
    ])
  ]

  v(-2em)

  align(left, [
    #set text(size: 1em)
    #set par()
    ★ 日期：#underline("  2025年      月      日  ", offset: 5pt)
    #h(1.5em)
    周次：#underline("  第      周  ", offset: 5pt) ★
  ])

  v(2em)

  // 计算需要填充的空项数量，合并原始列表和空元素
  let manifest = members.at(str(weekday))
  let member_count = manifest.len()
  let manifest = manifest + range(max_members - member_count).map(_ => "")

  // if member_count < max_members [
  //   #let manifest = manifest + range(max_members - member_count).map(_ => "")
  // ]

  // 生成表格行
  let items = manifest.map(
    (item) => ([#item], [], [], [], [])
  ).flatten()

  [
    #set text(number-type: "lining", 1em)

    #tablex(
      rows: 2.2em,
      columns: (2fr, 2fr, 2fr, 2fr, 4fr),
      align: center + horizon,
      auto-vlines: false,
      auto-hlines: true,
      // map-hlines: h => (..h, stroke: .4pt),
      map-vlines: v => (..v, stroke: .4pt),
      header-rows: 1,
      /* --- header --- */
      hlinex(stroke: 1.5pt),
        [*姓名*],
        vlinex(),
        [*替岗人/请假*],
        vlinex(),
        [*签入时间*],
        vlinex(),
        [*签出时间*],
        vlinex(),
        [*备注*],
      hlinex(stroke: 1.5pt),
      /* -------------- */
        ..items,
      hlinex(stroke: 1.5pt),
    )
  ]

  v(2em)

  box(baseline: 0%, width: 80%)[
    #align(left, [#set text(size: .8em)
    / 签入时间: 19:00 前记作 19:00，超过 19:00 如实记录；
    / 签离时间: [21:55,22:00] 记作 22:00，超过 22:00 如实记录并备注加班理由；
    / 上班期间外勤: 记录离开（和返回）C楼时间、外勤地点、内容；
    / 晚到/早退:
      - \[15,30) 分钟记迟到/早退；
      - \[30,90) 分钟记迟到/早退（半旷）；
      - \[90,180\] 分钟记迟到/早退（旷岗）；
    / 组长职责:
      + 提前抵达C楼三层南侧吧台准备好纸质版签到表、服务协议二维码等；
      + 组织队员签入与签退，19:45 前，确定未到岗同学的情况；
      + 接待来访师生并合理分配工作，随机抽取两位队员去312工作；
      + 下班后，整理维修工具，清洁工作场所；
      + 离开前，确认纸质签到表上的替班、请假、迟到、早退、外勤等情况；
      + 在 22:00 - 次日 19:00 完成电子版签到表（`https://checkin.kjfwd.com`）录入；
    / 特殊情况: 人手不足的情况下，未排班同学自愿上班，相应工时可以计入“爱心勤工”志愿工时。
  ])
  ]

  box(baseline: -67.5%, width: 20%)[
    #align(center, smallcaps[
      #set text(size: .8em)
      #image("../assets/checkin-qrcode.png", width: 80%)
    *当日当班组长\ 扫码录入工时*
    ])
  ]
}

#let generate_sheets = (members, max_members: 12) => {
  let weekday = 1
  while weekday < 8 {
    sheet(
      weekday: weekday,
      members: members,
      max_members: max_members
    )
    weekday = weekday + 1
  }
}
