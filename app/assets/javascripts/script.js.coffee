$ = jQuery

k1 = [300, 400, 600]
k2 = 0.840897
niveaux = ["NÉGLIGEABLE", "FAIBLE", "IMPORTANT", "SÉVÈRE"]
dosage = 0

l1 = 32.9155 #constantes pour la formule inverse
l2 = 13.2878 #
x_limit = 600
y_limit = 600
hours_factor = x_limit / 24
conc_factor = y_limit / 3

$ ->
  $("#rumack_container").svg
    settings:
      width: 800
      height: 700
      style: "float:left;"
      onmousemove: "mouse(evt)"

  svg = $("#rumack_container").svg('get')
  svg.script('var click=false;\n' +
  'var dosage = 0\n' +
  'var delai = 0\n' +
  'var gE = function (iid) { return document.getElementById(iid) }\n' +
  'var mouse = function (evt) {\n' +
  '  xm=evt.clientX; ym=evt.clientY;\n' +
  '  tx=110;ty=702;\n' +
  '  svgx=xm-tx;\n' +
  '  svgy=ty-ym;\n' +
  "  hours_factor=#{hours_factor};\n" +
  "  conc_factor=#{conc_factor};\n" +
  '  time=Math.floor(svgx/hours_factor);\n' +
  '  conc=Math.round(Math.pow(10,svgy/conc_factor));\n' +
  '  if (time>24) { time=24 };\n' +
  '  if (time<0) { time=0 };\n' +
  '  if (conc>1000) { conc=1000 };\n' +
  '  if (conc<0) { conc=0 };\n' +
  '  //gE("x").innerHTML = xm;\n' +
  '  //gE("y").innerHTML = ym;\n' +
  '  //gE("coord_x").innerHTML = svgx;\n' +
  '  //gE("coord_y").innerHTML = svgy;\n' +
  '  gE("time").innerHTML = time + " heures";\n' +
  '  gE("conc").innerHTML = conc + " mg/L";\n' +
  '}\n' +
  'var cliquer = function (evt) {\n' +
  '  click=true;\n' +
  '  svgdoc = evt.target.ownerDocument;\n' +
  '  var xm = evt.clientX, ym = evt.clientY; // window coordinates under mouse cursor\n' +
  '  var nx = xm-111, ny = 702-ym;\n' +
  '  var movex  = "translate(0," + ny + ")";\n' +
  '  var movey  = "translate(" + nx + ",0)";\n' +
  '  var move_conc = "translate(" + (nx + 45) + "," + (645 - ny) + ")";\n' +
  '  var move_delai = "translate(" + (nx + 108) + "," + (665 - ny) + ")";\n' +
  '  svgdoc.getElementById("hori").setAttributeNS(null, "transform", movex);\n' +
  '  svgdoc.getElementById("vert").setAttributeNS(null, "transform", movey);\n' +
  '  var conc = gE("conc").innerHTML.split(" ")[0];\n' +
  '  var delai = gE("time").innerHTML.split(" ")[0];\n' +
  '  gE("dosage").innerHTML = " " + conc + " mg/L";\n' +
  '  gE("delai").innerHTML = " " + delai + " heure(s)";\n' +
  '  var conc_text = svgdoc.getElementById("conc_text");\n' +
  '  var delai_text = svgdoc.getElementById("delai_text");\n' +
  '  conc_text.setAttributeNS(null, "transform", move_conc);\n' +
  '  conc_text.firstChild.nodeValue = conc + " mg/L";\n' +
  '  delai_text.setAttributeNS(null, "transform", move_delai);\n' +
  '  delai_text.firstChild.nodeValue = delai + " h";\n' +
  '}\n' +
  'var calc_risque = function () {\n' +
  '  var k1 = new Array ( 300, 400, 600 )\n' +
  '  var k2 = 0.840897\n' +
  '  var niveaux = new Array ( "négligeable", "faible", "important", "sévère" )\n' +
  '  var t = gE("time").innerHTML.split(" ")[0];\n' +
  '  var conc = gE("conc").innerHTML.split(" ")[0];\n' +
  '  var k2t = Math.pow(k2,t);\n' +
  'if (t >= 4)\n' +
  '  {\n' +
  '  if (conc >= Math.round(k2t*k1[2]))\n' +
  '    {\n' +
  '    gE("risque").innerHTML = niveaux[3] //sevère;\n' +
  '    gE("risque").style.color="red";\n' +
  '    }\n' +
  '  else if (conc >= Math.round(k2t*k1[1]))\n' +
  '    {\n' +
  '    gE("risque").innerHTML = niveaux[2] //important;\n' +
  '    gE("risque").style.color="orange";\n' +
  '    }\n' +
  '  else if (conc >= Math.round(k2t*k1[0]))\n' +
  '    {\n' +
  '    gE("risque").innerHTML = niveaux[1] //faible;\n' +
  '    gE("risque").style.color="lime";\n' +
  '    }\n' +
  '  else if (conc == 0)\n' +
  '    {\n' +
  '    gE("risque").innerHTML = "";\n' +
  '    }\n' +
  '  else\n' +
  '    {\n' +
  '    gE("risque").innerHTML = niveaux[0];\n' +
  '    gE("risque").style.color="white";\n' +
  '    }\n' +
  '  gE("seuil_f").innerHTML = Math.round(k2t*k1[0]);\n' +
  '  gE("seuil_i").innerHTML = Math.round(k2t*k1[1]);\n' +
  '  gE("seuil_s").innerHTML = Math.round(k2t*k1[2]);\n' +
  '  }\n' +
  'else\n' +
  '  {\n' +
  '  gE("risque").style.color="white";\n' +
  '  gE("risque").innerHTML = "indéterminable (paracétamolémie ininterprétable pour un délai < 4 heures)";\n' +
  '  }\n' +
  '};')
  svg.rect(0, 0, 800, 700,
    fill: 'white'
    stroke: 'black'
    strokeWidth: 1
  )
  # cartesian axis
  svg.rect(100, 50, x_limit, y_limit,
    fill: 'lightgrey'
    stroke: 'black'
    strokeWidth: 2
    onmousedown: "cliquer(evt);calc_risque()"
    onmousemove: "mouse(evt)"
    onmouseup:   "click=false"
  )
  # risk polygons
  # matrix to invert coordinates
  invert = svg.group
    transform: "matrix(1, 0, 0, -1, 100, 600)"
    strokeWidth:2
    onmousedown: "cliquer(evt);calc_risque()"
    onmousemove: "mouse(evt)"
    onmouseup:   "click=false"
  # red risk
  svg.polygon(invert, [[time_x(4),conc_y(1000)], [time_x(24),conc_y(1000)], [time_x(24),conc_y(9.38)], [time_x(4),conc_y(300)]], {fill:"salmon",stroke:"red"})
  # orange risk
  svg.polygon(invert, [[time_x(4),conc_y(300)], [time_x(24),conc_y(9.38)], [time_x(24),conc_y(6.25)], [time_x(4),conc_y(200)]], {fill:"wheat";stroke:"orange"})
  # green risk polygon
  svg.polygon(invert, [[time_x(4),conc_y(200)], [time_x(24),conc_y(6.25)], [time_x(24),conc_y(4.69)], [time_x(4),conc_y(150)]], {fill:"palegreen";stroke:"lime"})
  # white risk polygon
  svg.polygon(invert, [[time_x(4),conc_y(150)],[time_x(24),conc_y(4.69)],[time_x(24),conc_y(1)],[time_x(4),conc_y(1)]], {fill:"white";})

  # axis captions
  x_axis_settings = svg.group
    transform: "matrix(1, 0, 0, -1, 100, 650)"
    stroke: "grey"
    strokeWidth: 2
  # hours lines and labels
  x_labels_settings = svg.group
    transform: 'translate(100,650)'
    fontSize: 18
    strokeWidth: 2
    textAnchor: "end"
  for hour in [4, 8, 12, 16, 20]
    svg.line(x_axis_settings, time_x(hour), -8, time_x(hour), y_limit)
    svg.text(x_labels_settings, time_x(hour) + 5, 22, String(hour))
  svg.text(x_labels_settings, time_x(16), 42, "Délai après ingestion (heures)", {fontSize: 24})

  # concentration lines and labels
  y_axis_settings = svg.group
    transform: "matrix(1, 0, 0, -1, 100, 600)"
    stroke: "grey"
    strokeWidth: 2
    "stroke-dasharray": "5,6"
  y_labels_settings = svg.group
    transform: 'translate(90,5)'
    fontSize: 18
    strokeWidth: 2
    textAnchor: "end"

  for conc in [10, 100, 150, 200, 300]
    svg.line(y_axis_settings, 0, conc_y(conc), x_limit, conc_y(conc))
    svg.text(y_labels_settings, 0, 600 - conc_y(conc), String(conc))
  svg.text(y_labels_settings, -50, 250, "Paracétamolémie (µg/ml - mg/L)", {fontSize: 24, textAnchor: "middle", transform: "rotate(-90, 0, 300)"})

  # target cross
  targetcross = svg.group
    transform: "matrix(1, 0, 0, -1, 100, 650)"
    #transform: 'translate(100,50)'
    stroke: "black"
    strokeWidth: 2
  svg.line(targetcross, 0, 0, x_limit, 0, {id: "hori"}) #horizontal part of the cross
  svg.line(targetcross, 0, 0, 0, y_limit, {id: "vert"}) #verticatl part of the cross
  # conc and delai text
  svg.text(null, 0,0, 'conc', {id: "conc_text"})        # conc
  svg.text(null, 0,0, 'delai', {id: "delai_text"})      # delai

  $("#calc1").on 'submit', (event) ->
    event.preventDefault()
    calc_risque()
  $("#calc2").on 'submit', (event) ->
    event.preventDefault()
    calc_delai()

# Functions
time_x = (time) ->
  hours_factor * time
conc_y = (conc) ->
  conc_factor * custLog(conc,10) - 50
calc_risque = ->
  svg = $("#rumack_container").svg('get')
  hori = svg.getElementById("hori")
  vert = svg.getElementById("vert")
  conc_text = svg.getElementById("conc_text")
  delai_text = svg.getElementById("delai_text")
  t = $("#delai_for_calc").val()
  conc = $("#dosage_for_calc").val()
  k2t = Math.pow(k2,t)
  final_t = "#{t} heure(s)"
  final_conc = "#{conc} mg/L"
  if t and conc
    hori.setAttributeNS(null, "transform", "translate(0,#{conc_y(conc) + 50})")
    vert.setAttributeNS(null, "transform", "translate(#{time_x(t)},0)")
    conc_text.setAttributeNS(null, "transform", "translate(#{time_x(t) + 40},#{590 - conc_y(conc)})")
    delai_text.setAttributeNS(null, "transform", "translate(#{time_x(t) + 110},#{620 - conc_y(conc)})")
    conc_text.firstChild.nodeValue = final_conc
    delai_text.firstChild.nodeValue = final_t
    $("#dosage").html final_conc
    $("#delai").html final_t
    if t >= 4
      if conc >= Math.round(k2t*k1[2])
        $("#risque").html niveaux[3]
        $("#risque").css("color","red")
      else if conc >= Math.round(k2t*k1[1])
        $("#risque").html niveaux[2]
        $("#risque").css("color","orange")
      else if (conc >= Math.round(k2t*k1[0]))
        $("#risque").html niveaux[1]
        $("#risque").css('color',"lime")
      else if conc is 0
        $("#risque").html ""
      else
        $("#risque").html niveaux[0]
        $("#risque").css('color',"white")
      $("#seuil_f").html Math.round(k2t*k1[0])
      $("#seuil_i").html Math.round(k2t*k1[1])
      $("#seuil_s").html Math.round(k2t*k1[2])
    else
      $("#risque").color="white"
      $("#risque").html "indéterminable (paracétamolémie ininterprétable pour un délai < 4 heures)"

custLog = (x,base) ->
  # Created 1997 by Brian Risk.  http:#brianrisk.com
  Math.log(x) / Math.log(base)

calc_delai = ->
  dosage = $('#dosage_for_calc2').val()
  if dosage
    if dosage <= 150
      res = l1 - l2*(custLog(dosage,10))
      $('#securite').html ("< #{Math.round(res)} heures")
    else
      $('#securite').html "ininterprétable"
