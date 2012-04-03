$ = jQuery

k1 = [300, 400, 600]
k2 = 0.840897
niveaux = ["négligeable", "faible", "important", "sévère"]
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
      width: 700
      height: 700
      style: "float:left;"
      onmousemove: "mouse(evt)"

  svg = $("#rumack_container").svg('get')
  svg.script('var click=false;\n' +
  'var dosage = 0\n' +
  'var gE = function (iid) { return document.getElementById(iid) }\n' +
  'var mouse = function (evt) {\n' +
  '  xm=evt.clientX; ym=evt.clientY;\n' +
  '  tx=58;ty=732;\n' +
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
  '  var nx = xm-59, ny = ym-129;\n' +
  '  var movex  = "translate(" + "0," + ny + ")";\n' +
  '  var movey  = "translate(" + nx + ",0)";\n' +
  '  var move_conc = "translate(" + (nx - 18) + "," + (ny + 40) + ")";\n' +
  '  var move_delai = "translate(" + (nx + 58) + "," + (ny + 70) + ")";\n' +
  '  svgdoc.getElementById("hori").setAttributeNS(null, "transform", movex);\n' +
  '  svgdoc.getElementById("vert").setAttributeNS(null, "transform", movey);\n' +
  '  var conc = gE("conc").innerHTML.split(" ")[0];\n' +
  '  var delai = gE("time").innerHTML.split(" ")[0];\n' +
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
  '  var dosage = gE("conc").innerHTML.split(" ")[0];\n' +
  '  var k2t = Math.pow(k2,t);\n' +
  'if (t >= 4)\n' +
  '  {\n' +
  '  if (dosage >= Math.round(k2t*k1[2]))\n' +
  '    {\n' +
  '    gE("risque").innerHTML = niveaux[3] //sevère;\n' +
  '    gE("risque").style.color="red";\n' +
  '    }\n' +
  '  else if (dosage >= Math.round(k2t*k1[1]))\n' +
  '    {\n' +
  '    gE("risque").innerHTML = niveaux[2] //important;\n' +
  '    gE("risque").style.color="orange";\n' +
  '    }\n' +
  '  else if (dosage >= Math.round(k2t*k1[0]))\n' +
  '    {\n' +
  '    gE("risque").innerHTML = niveaux[1] //faible;\n' +
  '    gE("risque").style.color="lime";\n' +
  '    }\n' +
  '  else if (dosage == 0)\n' +
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
  svg.rect(0, 0, 700, 700,
    fill: 'white'
    stroke: 'black'
    strokeWidth: 1
  )
  # cartesian axis
  svg.rect(50, 50, x_limit, y_limit,
    fill: 'lightgrey'
    stroke: 'black'
    strokeWidth: 2
    onmousedown: "cliquer(evt);calc_risque()"
    onmousemove: "mouse(evt)"
    onmouseup:   "click=false"
  )
  # risk polygons
  time_x = (time) ->
    hours_factor * time
  conc_y = (conc) ->
    conc_factor * custLog(conc,10) - 50
  # matrix to invert coordinates
  invert = svg.group
    transform: "matrix(1, 0, 0, -1, 50, 600)"
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
  # target cross
  targetcross = svg.group
    transform: 'translate(50,50)'
    stroke: "black"
    strokeWidth: 2
  svg.line(targetcross, 0, 0, x_limit, 0, {id: "hori"}) #horizontal part of the cross
  svg.line(targetcross, 0, 0, 0, y_limit, {id: "vert"}) #verticatl part of the cross
  # conc and delai text
  svg.text(null, 0,0, 'conc', {id: "conc_text"})        # conc
  svg.text(null, 0,0, 'delai', {id: "delai_text"})      # delai

# Functions

custLog = (x,base) ->
  # Created 1997 by Brian Risk.  http:#brianrisk.com
  Math.log(x) / Math.log(base)
