---
layout: post
title: "Exploration of text Clustering"
categories: [Clustering]
tags: [levenshtein distance]
---

Our issue tonight is how to cluster text which have near match.
At disposition, we have a dataset of companies with the term edf inside. Our goal is to find function and ways to cluster altogether the same companies which had been entered with different names. It is a wide subject and to narrow it, we only look at the two functions, `agrep` and `adist`, which implement the Levenshtein distance.

## Initialisation



Load the data:



We attach the libraries.


{% highlight r %}
library(Ropencorporate, quietly = T)
library(data.table)
library(stringr)
library(DT)
{% endhighlight %}

## Data description

The dataset is a set of companies name and descriptions, all related to EDF, obtained in that [article](http://data-laborer.eu/2016/05/Presentation_of_the_Ropencorporate_package.html).

We use the package `DT` to get an overview:


{% highlight r %}
oc.dt <- res.oc$oc.dt[, list(.N), by = "name"]

datatable(oc.dt, options = list(pageLength = 10))
{% endhighlight %}

<!--html_preserve--><div id="htmlwidget-5496" style="width:100%;height:auto;" class="datatables"></div>
<script type="application/json" data-for="htmlwidget-5496">{
  "x": {
    "data": [
      ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100", "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125", "126", "127", "128", "129", "130", "131", "132", "133", "134", "135", "136", "137", "138", "139", "140", "141", "142", "143", "144", "145", "146", "147", "148", "149", "150", "151", "152", "153", "154", "155", "156", "157", "158", "159", "160", "161", "162", "163", "164", "165", "166", "167", "168", "169", "170", "171", "172", "173", "174", "175", "176", "177", "178", "179", "180", "181", "182", "183", "184", "185", "186", "187", "188", "189", "190", "191", "192", "193", "194", "195", "196", "197", "198", "199", "200", "201", "202", "203", "204", "205", "206", "207", "208", "209", "210", "211", "212", "213", "214", "215", "216", "217", "218", "219", "220", "221", "222", "223", "224", "225", "226", "227", "228", "229", "230", "231", "232", "233", "234", "235", "236", "237", "238", "239", "240", "241", "242", "243", "244", "245", "246", "247", "248", "249", "250", "251", "252", "253", "254", "255", "256", "257", "258", "259", "260", "261", "262", "263", "264", "265", "266", "267", "268", "269", "270", "271", "272", "273", "274", "275", "276", "277", "278", "279", "280", "281", "282", "283", "284", "285", "286", "287", "288", "289", "290", "291", "292", "293", "294", "295", "296", "297", "298", "299", "300", "301", "302", "303", "304", "305", "306", "307", "308", "309", "310", "311", "312", "313", "314", "315", "316", "317", "318", "319", "320", "321", "322", "323", "324", "325", "326", "327", "328", "329", "330", "331", "332", "333", "334", "335", "336", "337", "338", "339", "340", "341", "342", "343", "344", "345", "346", "347", "348", "349", "350", "351", "352", "353", "354", "355", "356", "357", "358", "359", "360", "361", "362", "363", "364", "365", "366", "367", "368", "369", "370", "371", "372", "373", "374", "375", "376", "377", "378", "379", "380", "381", "382", "383", "384", "385", "386", "387", "388", "389", "390", "391", "392", "393", "394", "395", "396", "397", "398", "399", "400", "401", "402", "403", "404", "405", "406", "407", "408", "409", "410", "411", "412", "413", "414", "415", "416", "417", "418", "419", "420", "421", "422", "423", "424", "425", "426", "427", "428", "429", "430", "431", "432"],
      ["\"EDF ENGINEERING SRL\"", "\"EDF TRADING LIMITED LONDON SUCURSALA BUCURESTI\"", "\"EDF Énergies Nouvelles Belgium\" en abrégé \"EDF EN Belgium\"", "\"EDF\" SPÓŁKA Z OGRANICZONĄ ODPOWIEDZIALNOŚCIĄ", "128 EDF, LLC", "1405940 NOVA SCOTIA LIMITED", "3235432 CANADA INC.", "9189-0558 QUÉBEC INC.", "9200-6881 QUÉBEC INC.", "ALPHA REPROGRAPHIC SERVICES, INC.", "AMERADA COMMUNICATIONS LIMITED", "AMHERST EDF, LLC", "BECK BURN WINDFARM LIMITED", "BLOOMFIELD APARTMENTS, LLC", "BMR PROPERTY SOLUTIONS LIMITED", "BOUNDARY LANE WINDFARM LIMITED", "BRAEMORE WOOD WINDFARM LIMITED", "BRITISH ENERGY GENERATION LIMITED", "BRITISH ENERGY GROUP LIMITED", "BROOKRIDGE EDF HOUSING INVESTORS, L.P.", "CASA DE SCHIMB VALUTAR E D F ASRO SRL", "CHELSEA EDF PARKWAY, LLC", "CONSTRUCTION EDF INC.", "CONTRACT FINANCIAL, LLC", "CORRIEMOILLIE WINDFARM LIMITED", "Coastal EDF, Inc.", "DANIEL FRADETTE", "DESIGN2C v/Ellen Dahl Frederiksen", "DÉVELOPPEMENT EDF EN CANADA INC.", "E D F ADVERTISING, INC.", "E D F ASSOCIATES, INC.", "E D F BUSINESS CLUB INC.", "E D F CONSTRUCTION INC.", "E D F ENTERPRISES, INC.", "E D F FARM &amp; FEEDERS, INC.", "E D F MAN ESPAÑA SA", "E D F SA", "E D F TRADING LIMITED", "E D F WATERTOWN, INC.", "E D F, L.L.C.", "E. D. F. LIMITED", "E. D. F. LIMITED, INC.", "E. D. F. MULTI SERVICES &amp; CARGO INC.", "E. D. F. RESOURCES, INC.", "E. D. F. VENTURES, INC.", "E. D. F., INC.", "E.D.F Remodeling Inc.", "E.D.F TRADING", "E.D.F.", "E.D.F. (AUSTRALIA) PTY LTD", "E.D.F. ASSOCIÉS", "E.D.F. CONCRETE, INC.", "E.D.F. CONSTRUCTION, INC.", "E.D.F. DESIGN &amp; CONSTRUCTION, INC.", "E.D.F. ECONOMIE", "E.D.F. ENGINEERING LIMITED", "E.D.F. ENTERPRISES, INC.", "E.D.F. FASHIONS, INC.", "E.D.F. FISHERIES LIMITED", "E.D.F. HOLDING CORP.", "E.D.F. INCORPORATED", "E.D.F. INDUSTRIES, INC.", "E.D.F. LLC", "E.D.F. MANAGEMENT CORPORATION", "E.D.F. MARKETING, INC.", "E.D.F. MEN, TRGOVINA, PROIZVODNJA, STORITVE, D.O.O.", "E.D.F. PAINTING, LLC", "E.D.F. PROPERTIES, LLC", "E.D.F. REALTY CORP.", "E.D.F. RESOURCES, INC.", "E.D.F. Remodeling Inc.", "E.D.F. WATERFORD, LLC", "E.D.F. WIND FARM SRL", "E.D.F., COMPANY, INCORPORATED", "E.D.F., INC.", "E.D.F., LLC", "EASTERN POWER NETWORKS PLC", "ECOLE DANSE FORMATION DE L'ESTRIE INC.", "EDF", "EDF &amp; ASSOCIATES INC.", "EDF &amp; ASSOCIATES, INC.", "EDF &amp; Associates Consulting, LLC", "EDF (PROPERTIES) LIMITED", "EDF (SERVICES) LIMITED", "EDF (SKY SERVICES) LIMITED", "EDF (USA), INC.", "EDF (VIETNAM) LIMITED", "EDF + SPACE PLANNERS PTE. LTD.", "EDF - EXPERT DEALING FINANCING", "EDF - PROGRESS INCORPORATED", "EDF 2 INC.", "EDF 2005 GP INC.", "EDF 2005 GP Inc.", "EDF ABACEBISI", "EDF ACQUISITION COMPANY, INC.", "EDF ADVISORS LLC", "EDF AIR CONDITIONING LIMITED", "EDF AMERICAS FINANCE CO., LLC", "EDF ANSTALT", "EDF ARSENAL WATERTOWN HOLDINGS, LLC", "EDF ASRO SRL", "EDF ASSOCIATES LIMITED", "EDF AVIATION LLC", "EDF B.V.", "EDF BELGIUM", "EDF BENELUX BV", "EDF BUILDERS INCORPORATED", "EDF Beheer B.V.", "EDF Benelux B.V.", "EDF CAPITAL, LLC", "EDF COLLECTION MANAGEMENT NETWORK LTD", "EDF COLLECTION SERVICES NETWORK LTD", "EDF COLLECTIONS LTD", "EDF COMMUNICATION PRODUCTS, INC.", "EDF COMMUNICATIONS LLC", "EDF COMMUNICATIONS, INC.", "EDF COMPANY INC", "EDF COMPANY, LLC", "EDF CONCEPTS LIMITED", "EDF CONSORTIUM, LLC", "EDF CONSTRUCTIONS PTY LIMITED", "EDF CONSULTANTS LIMITED", "EDF CONSULTANTS, INC.", "EDF CONSULTING", "EDF CONSULTING GROUP LIMITED", "EDF CONSULTING LLC", "EDF CONSULTING SA", "EDF CONSULTING, INC.", "EDF CONTRACTING, LLC", "EDF CORP.", "EDF Consulting", "EDF DANCE STUDIO LIMITED", "EDF DANVERS HOLDINGS, LLC", "EDF DANVERS II, LLC", "EDF DANVERS, LLC", "EDF DATAPRODUKTER HANDELSBOLAG", "EDF DESIGNS, INC.", "EDF DEVELOPMENT COMPANY LIMITED", "EDF DEVELOPMENT SA", "EDF DEVELOPMENT, INC.", "EDF DIN UK LIMITED", "EDF DIRECT PTY LIMITED", "EDF DISTRIBUTION INC.", "EDF DISTRIBUTORS AND DUTY FREE SHOPS LIMITED", "EDF DRESDEN LTD", "EDF ELECTRIC, INC.", "EDF EN CANADA DEVELOPMENT INC. - DÉVELOPPEMENT EDF EN CANADA INC.", "EDF EN CANADA INC.", "EDF EN Canada Distributed Solar GP Inc.", "EDF EN Canada Inc.", "EDF EN Canada Solar Arnprior A GP Inc.", "EDF EN Canada Solar Arnprior B GP Inc.", "EDF EN Canada Solar Smiths Falls A GP Inc.", "EDF EN Canada Solar Smiths Falls B GP Inc.", "EDF EN Canada Solar St. Isidore A GP Inc.", "EDF EN DENMARK A/S", "EDF EN OSTERILD ApS", "EDF EN POLSKA SPÓŁKA Z OGRANICZONĄ ODPOWIEDZIALNOŚCIĄ", "EDF EN SERVICES UK LIMITED", "EDF EN SOUTH AFRICA", "EDF EN Services Belgium", "EDF EN UK LIMITED", "EDF ENERGIES NOUVELLES", "EDF ENERGY (CONTRACT SERVICES) LIMITED", "EDF ENERGY (COTTAM POWER) LIMITED", "EDF ENERGY (D1) LIMITED", "EDF ENERGY (D2) LIMITED", "EDF ENERGY (DORMANT HOLDINGS) LIMITED", "EDF ENERGY (ENERGY BRANCH) PLC", "EDF ENERGY (GAS STORAGE HOLE HOUSE) LIMITED", "EDF ENERGY (LONDON HEAT AND POWER) LIMITED", "EDF ENERGY (METRO HOLDINGS) LIMITED", "EDF ENERGY (NORTHERN OFFSHORE WIND) LIMITED", "EDF ENERGY (PROJECTS) LIMITED", "EDF ENERGY (SOUTH EAST GENERATION) LIMITED", "EDF ENERGY (UK) LIMITED", "EDF ENERGY (WEST BURTON POWER) LIMITED", "EDF ENERGY 1 LIMITED", "EDF ENERGY CUSTOMER FIELD SERVICES (DATA) LIMITED", "EDF ENERGY CUSTOMER FIELD SERVICES (METERING) LIMITED", "EDF ENERGY CUSTOMERS PLC", "EDF ENERGY DISTRIBUTION FUND LIMITED", "EDF ENERGY ESPS TRUSTEE LIMITED", "EDF ENERGY FLEET SERVICES LIMITED", "EDF ENERGY GB LIMITED", "EDF ENERGY GROUP HOLDINGS PLC", "EDF ENERGY HOLDINGS LIMITED", "EDF ENERGY HOMEPHONE LIMITED", "EDF ENERGY INVESTMENTS", "EDF ENERGY LAKE LIMITED", "EDF ENERGY NUCLEAR GENERATION GROUP LIMITED", "EDF ENERGY NUCLEAR GENERATION LIMITED", "EDF ENERGY PENSION SCHEME TRUSTEE LIMITED", "EDF ENERGY PLC", "EDF ENERGY POWER SYSTEMS (EASTERN) LIMITED", "EDF ENERGY POWER SYSTEMS (LONDON) LIMITED", "EDF ENERGY POWER SYSTEMS (SOUTH EASTERN) LIMITED", "EDF ENERGY POWERCOM SYSTEMS (LONDON) LIMITED", "EDF ENERGY PROPERTY SERVICES LIMITED", "EDF ENERGY R&amp;D UK CENTRE LIMITED", "EDF ENERGY RENEWABLES HOLDINGS LIMITED", "EDF ENERGY RENEWABLES LIMITED", "EDF ENERGY ROUND 3 ISLE OF WIGHT LIMITED", "EDF ENERGY SERVICES LIMITED LIABILITY COMPANY", "EDF ENERGY SERVICES, LLC", "EDF ENGINEERING UND DESIGN IM FAHRZEUGBAU LTD", "EDF ENTERPRISES DW LLC", "EDF ENTERPRISES GV, LLC", "EDF ENTERPRISES HOLDING, LLC", "EDF ENTERPRISES LIMITED LIABILITY COMPANY", "EDF ENTERPRISES PTY LTD", "EDF ENTERPRISES, BX, LLC", "EDF ENTERPRISES, INC.", "EDF ENTERPRISES, LLC", "EDF ENTERPRISES, UA, LLC", "EDF ESTATICA Y DINAMICA DE FLUIDOS SA", "EDF EURO AMERICANA", "EDF EURO-DOMUS-FINANZ S.A.", "EDF EXCELSIOR LLC", "EDF Energy (NNB) Limited", "EDF Energy Services, LLC", "EDF Express", "EDF FARMS LLC", "EDF FILTER SOLUTIONS LIMITED", "EDF FINANCE MANAGEMENT NETWORK LTD", "EDF FINANCIAL CONCEPTS, INC.", "EDF FINANCING CORP.", "EDF FLOWERS L.L.C.", "EDF GROUP INC", "EDF GROUP, LLC", "EDF HOLDCO LLC", "EDF HOLDING ApS", "EDF HOLDING CO. LIMITED", "EDF HOLDING CO.,LTD.", "EDF HOLDINGS (USA) INC.", "EDF HOLDINGS PTY LIMITED", "EDF HOLDINGS, LLC", "EDF INC.", "EDF INC. WHICH WILL DO BUSINESS IN CALIFORNIA AS EDF POWER INC.", "EDF INDUSTRIAL POWER SERVICES (CA) LLC", "EDF INDUSTRIAL POWER SERVICES (CA), LLC", "EDF INDUSTRIAL POWER SERVICES (IL), LLC", "EDF INDUSTRIAL POWER SERVICES (NY), LLC", "EDF INDUSTRIAL POWER SERVICES (OH), LLC", "EDF INTERNATIONAL PTE. LTD.", "EDF INVESTISSEMENTS GROUPE", "EDF INVESTMENT PARTNERS, L.L.C.", "EDF INVESTMENTS LLC", "EDF INVESTMENTS LLP", "EDF INVESTMENTS PTY LIMITED", "EDF INVESTMENTS SL", "EDF INVESTMENTS, LLC", "EDF INVESTORS GROUP, L.L.C.", "EDF INVESTORS, L.L.C.", "EDF INVESTORS, LLC", "EDF IONEL PERLEA RESIDENCE LIMITED", "EDF ISLAMABAD (PRIVATE) LIMITED", "EDF Inc.", "EDF International (Europe Déménagements Fournitures International)", "EDF JUICES PRIVATE LIMITED", "EDF LAB SINGAPORE PTE. LTD.", "EDF LANCASTER SOLAR LLC", "EDF LEISURE LTD", "EDF LEPOMIS SOLAR LLC", "EDF LIMITED", "EDF LLC", "EDF LOGITECH SRL", "EDF LONDON CAPITAL, L.P.", "EDF LONDON HOLDINGS", "EDF LONDON LIMITED", "EDF LTD.", "EDF LUMINAIRES", "EDF LUXURY DESIGNS, INC.", "EDF Luminus", "EDF Luminus Wind Together", "EDF MANAGEMENT, LLC", "EDF MANTON AVENUE, LLC", "EDF MASS AVE, LLC", "EDF MASSACHUSETTS SOLAR HOLDINGS, LLC", "EDF MASSACHUSETTS SPONSOR MEMBER, LLC", "EDF MEDICAL P.C.", "EDF MIDDLETOWN, LLC", "EDF Management, LLC", "EDF Manton Avenue, LLC", "EDF NC SOLAR, LLC", "EDF NETWORK LLC", "EDF NORTH DARTMOUTH I, INC.", "EDF NORTH DARTMOUTH I, LLC", "EDF NORTH DARTMOUTH II, LLC", "EDF NORTH DARTMOUTH, LLC", "EDF NUCLEAR LLC", "EDF OCEANTRANSPORT INC.", "EDF PARENT BOOSTER", "EDF PARTNERS, L.P.", "EDF PENINSULA IBERICA SL", "EDF POLSKA CENTRALA SPÓŁKA Z OGRANICZONĄ ODPOWIEDZIALNOŚCIĄ", "EDF POLSKA CUW SPÓŁKA Z OGRANICZONĄ ODPOWIEDZIALNOŚCIĄ", "EDF PORTSMOUTH, LLC", "EDF POWER INC.", "EDF PRODUCTS, INC.", "EDF PROPERTIES, LLC", "EDF PROPERTY SOLUTIONS, LLC", "EDF PTY LIMITED", "EDF PUB INC.", "EDF PV COMPANY SL", "EDF Partners, LLC", "EDF Partnership SCSp", "EDF Properties, LLC", "EDF Quality Consulting LLC", "EDF REALTY", "EDF REALTY INC.", "EDF RENDER SYSTEMS LIMITED", "EDF RENEWABLE ASSET HOLDINGS, INC.", "EDF RENEWABLE DEVELOPMENT, INC.", "EDF RENEWABLE DG SERVICES LLC", "EDF RENEWABLE EAST COAST, INC.", "EDF RENEWABLE ENERGY, INC.", "EDF RENEWABLE LAND HOLDINGS, INC.", "EDF RENEWABLE LFG HOLDINGS, LLC", "EDF RENEWABLE SERVICES INC.", "EDF RENEWABLE SERVICES, INC.", "EDF RENEWABLE SOLAR HOLDINGS, INC.", "EDF RENEWABLE WINDFARM I, INC.", "EDF RENEWABLE WINDFARM III, INC.", "EDF RENEWABLE WINDFARM IV, INC.", "EDF RENEWABLE WINDFARM V, INC.", "EDF RENEWABLE WINDFARM VI, INC.", "EDF RESEARCH INC.", "EDF RESOURCE CAPITAL, INC.", "EDF RESTORATION SERVICES, INC.", "EDF RIVERSIDE PLAZA, LLC", "EDF Renewable Asset Holdings, Inc.", "EDF Renewable Development, Inc.", "EDF Renewable LFG Holdings, LLC", "EDF Renewable Services", "EDF Renewable Services Inc.", "EDF Renewable Services, Inc.", "EDF Resource Capital, Inc.", "EDF Riverside Plaza, LLC", "EDF SALES &amp; MARKETING, INC.", "EDF SCARBOROUGH, LLC", "EDF SCHOOL OF DANCE &amp; ELITE DANCE FASHIONS, L.L.C.", "EDF SECURITY ENTERPRISES INC.", "EDF SEEKONK II, LLC", "EDF SEEKONK THREE, LLC", "EDF SEEKONK, LLC", "EDF SERVICES (PRIVATE.) LIMITED", "EDF SERVICES LIMITED", "EDF SERVICES LLC", "EDF SERVICES, INC.", "EDF SHIELD LIMITED", "EDF SOLAR ENERGY LTD", "EDF SOLAR I, LLC", "EDF SOLAR II, LLC", "EDF SOLAR SOCIEDAD LIMITADA", "EDF SOLUTIONS LIMITED", "EDF SOUTH EAST ASIA COMPAY LIMITED", "EDF SRL", "EDF SYSTEMS, INC.", "EDF Septen", "EDF Sitestreet", "EDF Sky EuroCore S.à r.l.", "EDF Sky GPF S.à r.l.", "EDF Sky KSH S.à r.l.", "EDF Sky S.à r.l.", "EDF Solutions", "EDF Solutions, LLC", "EDF TAX CONTRACTOR SUPPORT LIMITED", "EDF TAX DEFENCE LIMITED", "EDF TAX LIMITED", "EDF TAX PREMIER SUPPORT LIMITED", "EDF TECHNOLOGIES DE L'INFORMATION INC.", "EDF TECHNOLOGIES LLC", "EDF TEMPLE TERRACE, LLC", "EDF TERRACE RIDGE, LLC", "EDF TRADERS INC.", "EDF TRADING", "EDF TRADING AUSTRALIA PTY LIMITED", "EDF TRADING BIOENERGY LIMITED", "EDF TRADING ELECTRICIDAD Y GAS SL", "EDF TRADING HOLDINGS LLC", "EDF TRADING LIMITED", "EDF TRADING LIMITED NORSK AVDELING AV UTENLANDSK FORETAK", "EDF TRADING LTD", "EDF TRADING MARKETS LIMITED", "EDF TRADING NORTH AMERICA LIMITED LIABILITY COMPANY", "EDF TRADING NORTH AMERICA MANAGEMENT LLC", "EDF TRADING NORTH AMERICA, LLC", "EDF TRADING RESOURCES, LLC", "EDF TRADING SINGAPORE PTE. LIMITED", "EDF TRANSPORT", "EDF TRANSPORT LIMITED", "EDF TRANSPORT, INC.", "EDF TRANSPORTS INC.", "EDF TRUCK LLC", "EDF Technologies Limited", "EDF Teknik Aktiebolag", "EDF Trading Limited", "EDF Trading North America, LLC", "EDF Transport", "EDF UK FINANCE", "EDF VAPORS LLC", "EDF VENTURES I, LIMITED PARTNERSHIP", "EDF VENTURES II, LIMITED PARTNERSHIP", "EDF VENTURES III HEALTHCARE OPPORTUNITY FUND, LIMITED PARTNERSHIP", "EDF VENTURES III SIDECAR, LIMITED PARTNERSHIP", "EDF VENTURES III, LIMITED PARTNERSHIP", "EDF VENTURES OPPORTUNITY FUND, LIMITED PARTNERSHIP", "EDF VENTURES, LLC", "EDF WARWICK, LLC", "EDF WATERTOWN II, LLC", "EDF WATERTOWN, INC.", "EDF WATERTOWN, LLC", "EDF WEST, LLC", "EDF WESTBOROUGH, LLC", "EDF WINDUP CORPORATION", "EDF Warwick, LLC", "EDF Y GDF SL", "EDF, INC.", "EDF, INCORPORATED", "EDF, Inc.", "EDF, L.L.C.", "EDF, LLC", "EDF-ASSOCIATES, LLC", "EDF-Flexoprint", "EDF-M1 MANAGEMENT LLC", "EDF-M1 ONSHORE, L.P.", "EDF-MED (IMPORT &amp; DISTRIBUTION GROUP) LIMITED", "EDF-RE TEXAS DEVELOPMENT I, LLC", "EDF-RE TEXAS DEVELOPMENT II, LLC", "EDF-RE TEXAS DEVELOPMENT III, LLC", "EDF-RE US DEVELOPMENT, LLC"],
      [1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 3, 2, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 4, 1, 1, 1, 1, 1, 2, 1, 1, 2, 3, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 2, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 1, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 18, 1, 2, 5, 2, 3, 1, 21, 1, 2, 2, 2, 2, 2, 1, 8, 1, 1, 1, 4, 2, 1, 2, 6, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 4, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 24, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 6, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 6, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1]
    ],
    "container": "<table class=\"display\">\n  <thead>\n    <tr>\n      <th> </th>\n      <th>name</th>\n      <th>N</th>\n    </tr>\n  </thead>\n</table>",
    "options": {
      "pageLength": 10,
      "columnDefs": [
        {
          "orderable": false,
          "targets": 0
        },
        {
          "className": "dt-right",
          "targets": 2
        }
      ],
      "order": [],
      "autoWidth": false
    },
    "callback": "function(table) {\nreturn table;\n}",
    "filter": "none"
  },
  "evals": ["callback"]
}</script><!--/html_preserve-->

## First try: agrep

The function `agrep` allow to do approximate match.
We create a matrix of match and count for each name of companies, the number of times we could find a valuable match.


{% highlight r %}
# create the matrix of matchs
res <- matrix(NA, nrow = length(oc.dt[, name]), ncol = length(oc.dt[, name]))
for(idx in 1:length(oc.dt[, name])){
  res[, idx] <- agrepl(oc.dt[idx, name], oc.dt[, name])
}

res.sum <- apply(res, 2, sum)
res.sel.pos <- which(res.sum > 1)
{% endhighlight %}

The result is displayed in a datatable format as well.


{% highlight r %}
datatable(data.frame(name = oc.dt[res.sel.pos, name]
   , freq = res.sum[res.sel.pos], stringsAsFactors = T))
{% endhighlight %}

<!--html_preserve--><div id="htmlwidget-9162" style="width:100%;height:auto;" class="datatables"></div>
<script type="application/json" data-for="htmlwidget-9162">{
  "x": {
    "data": [
      ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100", "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122"],
      ["\"EDF\" SPÓŁKA Z OGRANICZONĄ ODPOWIEDZIALNOŚCIĄ", "DÉVELOPPEMENT EDF EN CANADA INC.", "E D F ASSOCIATES, INC.", "E D F ENTERPRISES, INC.", "E D F SA", "E D F TRADING LIMITED", "E D F WATERTOWN, INC.", "E D F, L.L.C.", "E. D. F. LIMITED", "E. D. F. RESOURCES, INC.", "E. D. F., INC.", "E.D.F Remodeling Inc.", "E.D.F TRADING", "E.D.F.", "E.D.F. ENTERPRISES, INC.", "E.D.F. LLC", "E.D.F. PROPERTIES, LLC", "E.D.F. RESOURCES, INC.", "E.D.F. Remodeling Inc.", "E.D.F., INC.", "E.D.F., LLC", "EDF", "EDF &amp; ASSOCIATES INC.", "EDF &amp; ASSOCIATES, INC.", "EDF (SERVICES) LIMITED", "EDF 2005 GP INC.", "EDF 2005 GP Inc.", "EDF ASRO SRL", "EDF COMMUNICATIONS LLC", "EDF CONSULTANTS, INC.", "EDF CONSULTING", "EDF CONSULTING SA", "EDF DEVELOPMENT SA", "EDF DEVELOPMENT, INC.", "EDF DIN UK LIMITED", "EDF EN CANADA INC.", "EDF EN Canada Solar Arnprior A GP Inc.", "EDF EN Canada Solar Arnprior B GP Inc.", "EDF EN Canada Solar Smiths Falls A GP Inc.", "EDF EN Canada Solar Smiths Falls B GP Inc.", "EDF EN UK LIMITED", "EDF ENERGY (D1) LIMITED", "EDF ENERGY (D2) LIMITED", "EDF ENERGY (UK) LIMITED", "EDF ENERGY 1 LIMITED", "EDF ENERGY GB LIMITED", "EDF ENERGY LAKE LIMITED", "EDF ENERGY PLC", "EDF ENERGY POWER SYSTEMS (LONDON) LIMITED", "EDF ENERGY POWERCOM SYSTEMS (LONDON) LIMITED", "EDF ENERGY SERVICES, LLC", "EDF ENTERPRISES DW LLC", "EDF ENTERPRISES GV, LLC", "EDF ENTERPRISES, BX, LLC", "EDF ENTERPRISES, INC.", "EDF ENTERPRISES, LLC", "EDF ENTERPRISES, UA, LLC", "EDF HOLDINGS, LLC", "EDF INC.", "EDF INDUSTRIAL POWER SERVICES (CA) LLC", "EDF INDUSTRIAL POWER SERVICES (CA), LLC", "EDF INDUSTRIAL POWER SERVICES (IL), LLC", "EDF INDUSTRIAL POWER SERVICES (NY), LLC", "EDF INDUSTRIAL POWER SERVICES (OH), LLC", "EDF INVESTMENTS LLC", "EDF INVESTMENTS LLP", "EDF INVESTMENTS SL", "EDF INVESTMENTS, LLC", "EDF INVESTORS, L.L.C.", "EDF INVESTORS, LLC", "EDF Inc.", "EDF LIMITED", "EDF LLC", "EDF Luminus", "EDF NORTH DARTMOUTH I, INC.", "EDF NORTH DARTMOUTH I, LLC", "EDF NORTH DARTMOUTH II, LLC", "EDF NORTH DARTMOUTH, LLC", "EDF POLSKA CUW SPÓŁKA Z OGRANICZONĄ ODPOWIEDZIALNOŚCIĄ", "EDF POWER INC.", "EDF PTY LIMITED", "EDF REALTY", "EDF RENEWABLE LAND HOLDINGS, INC.", "EDF RENEWABLE SERVICES INC.", "EDF RENEWABLE SERVICES, INC.", "EDF RENEWABLE SOLAR HOLDINGS, INC.", "EDF RENEWABLE WINDFARM I, INC.", "EDF RENEWABLE WINDFARM III, INC.", "EDF RENEWABLE WINDFARM IV, INC.", "EDF RENEWABLE WINDFARM V, INC.", "EDF RENEWABLE WINDFARM VI, INC.", "EDF Renewable Services", "EDF Renewable Services Inc.", "EDF Renewable Services, Inc.", "EDF SERVICES LIMITED", "EDF SERVICES LLC", "EDF SERVICES, INC.", "EDF SOLAR I, LLC", "EDF SOLAR II, LLC", "EDF SOLUTIONS LIMITED", "EDF SRL", "EDF Solutions", "EDF TRADING", "EDF TRADING LIMITED", "EDF TRADING LTD", "EDF TRADING NORTH AMERICA, LLC", "EDF TRANSPORT", "EDF TRANSPORT, INC.", "EDF TRANSPORTS INC.", "EDF VENTURES I, LIMITED PARTNERSHIP", "EDF VENTURES II, LIMITED PARTNERSHIP", "EDF VENTURES III, LIMITED PARTNERSHIP", "EDF WATERTOWN II, LLC", "EDF WATERTOWN, INC.", "EDF WATERTOWN, LLC", "EDF, INC.", "EDF, Inc.", "EDF, L.L.C.", "EDF, LLC", "EDF-RE TEXAS DEVELOPMENT I, LLC", "EDF-RE TEXAS DEVELOPMENT II, LLC", "EDF-RE TEXAS DEVELOPMENT III, LLC"],
      [4, 2, 2, 3, 7, 4, 2, 2, 2, 2, 2, 2, 17, 30, 3, 2, 2, 2, 2, 3, 4, 384, 2, 3, 2, 2, 2, 2, 2, 2, 7, 3, 2, 3, 2, 3, 2, 2, 2, 2, 2, 4, 3, 4, 2, 2, 2, 17, 2, 2, 2, 3, 5, 3, 4, 2, 3, 2, 5, 5, 5, 5, 5, 5, 4, 5, 5, 3, 2, 2, 3, 35, 4, 2, 2, 4, 4, 3, 2, 2, 2, 2, 2, 2, 2, 2, 5, 5, 5, 5, 5, 3, 2, 2, 3, 3, 2, 2, 2, 3, 7, 2, 17, 4, 4, 2, 4, 2, 2, 3, 3, 3, 2, 2, 2, 6, 3, 3, 4, 3, 3, 3]
    ],
    "container": "<table class=\"display\">\n  <thead>\n    <tr>\n      <th> </th>\n      <th>name</th>\n      <th>freq</th>\n    </tr>\n  </thead>\n</table>",
    "options": {
      "columnDefs": [
        {
          "orderable": false,
          "targets": 0
        },
        {
          "className": "dt-right",
          "targets": 2
        }
      ],
      "order": [],
      "autoWidth": false
    },
    "callback": "function(table) {\nreturn table;\n}",
    "filter": "none"
  },
  "evals": ["callback"]
}</script><!--/html_preserve-->

Our first result is nice and give for each name the number of fuzzy match.

## Second try: adist

The function `adist` allows to create a matrix of distance between names.

From the moment we have a matrix of distance, it is possible to do an hierachical clustering.


{% highlight r %}
n <- 75
d <- adist(x = oc.dt[1:n, name], y = oc.dt[1:n, name])
rownames(d) <- oc.dt[1:n, name]
hc <- hclust(as.dist(d))
{% endhighlight %}

The dendogram is nice to plot, showing the similarities from a wide point of view, as we include in the same graph up to 75 names.


{% highlight r %}
plot(hc)
{% endhighlight %}

![plot of chunk unnamed-chunk-7](https://london-r-dojo.github.iofigure/source/2016-05-11-Test_fuzzy_match/unnamed-chunk-7-1.png) 
