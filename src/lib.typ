#import "@preview/tablex:0.0.9": hlinex, vlinex, tablex

#let sheet(
  title: "科技服务分队C楼岗签到表",
  weekday: 1,
  members: none,
  max_members: none,
  volunteer_enabled: true,
) = {
  set text(lang: "zh", region: "cn")

  set page(paper: "a4", margin: (x: 10%, y: 10%, top: 3%, bottom: 3%))

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

  v(1.5em)

  // 计算需要填充的空项数量，合并原始列表和空元素
  let manifest = members.at(str(weekday))
  let member_count = manifest.len()
  // let manifest = manifest + range(max_members - member_count).map(_ => "")

  // if member_count < max_members [
  //   #let manifest = manifest + range(max_members - member_count).map(_ => "")
  // ]

  // 生成表格行
  let items = manifest.map(
    (item) => ([#item], [], [], [], [])
  ).flatten()

  let manifest2 = range(max_members - member_count).map(_ => "")

  // 生成表格行
  let volunteer_text = if volunteer_enabled { "爱心勤工" } else { "" }
  let items2 = manifest2.map(
    (item) => ([], volunteer_text, [], [], [])
  ).flatten()

  let items = items + items2
  [
    #set text(number-type: "lining", .9em)

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

  // v(1em)

  box(baseline: 0%, width: 80%)[
    #align(left, [#set text(size: .8em)
    / 签入时间: 19\:00前记作19\:00，超过19\:00如实记录；
    / 签离时间: \[21\:55,22\:00\] 记作 22\:00，超过22\:00 如实记录并备注加班理由；
    / 上班期间外勤: 记录离开（和返回）C楼时间、外勤地点、内容；
    / 晚到/早退:
      - \[15,30\) 分钟记迟到/早退；
      - \[30,90\) 分钟记迟到/早退（半旷），
      - \[90,180\] 分钟记迟到/早退（旷岗）；
    / 迟到豁免:
      - 临时t班：当班队员没有及时求替，此时被替队员会扣除0.5工时；
      - 合理迟到：合理原因，如外勤、生病、上班后替班（当班队员已提前求t不扣除工时）等。
    / 组长职责:
      + 提前抵达C楼三层南侧吧台准备好纸质版签到表、服务协议二维码等；
      + 组织队员签入与签退，19\:45前，确定未到岗同学的情况；
      + 接待来访师生并合理分配工作，安排老队员带教新队员；
      + 下班前确保纸质签到表上的替班、请假、迟到、早退、外勤、加班等记录清晰无误，并在22\:00-次日19\:00完成电子版签到表（`https://checkin.kjfwd.com`）录入；
      + 下班后收拾确保吧台区域收纳完成，并连同签到表一起拍照发送至企业微信指定群聊；
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

#let generate_sheets = (members, max_members: 12, volunteer_enabled: true) => {
  let weekday = 1
  while weekday < 8 {
    sheet(
      weekday: weekday,
      members: members,
      max_members: max_members,
      volunteer_enabled: volunteer_enabled,
    )
    weekday = weekday + 1
  }
}
