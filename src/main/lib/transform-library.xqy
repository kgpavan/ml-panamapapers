xquery version "1.0-ml";

module namespace transform = "http://marklogic.com/pp/transform";

declare variable $IRI-PREFIX := "http://panamapapers.icij.org/";
declare variable $RDF-PREFIX := "http://www.w3.org/2000/01/rdf-schema#";
declare variable $RDFS-PREFIX := "http://www.w3.org/1999/02/22-rdf-syntax-ns#";

declare function transform:camelize(
$string) {
  fn:string-join(
  	for $t at $pos in fn:tokenize($string,"[\s\-_\.]")
  	return 
  	  fn:replace(
  	  	fn:concat(
	  	  	if($pos gt 1) 
	  	  	then fn:upper-case(fn:substring($t,1,1))
	  	  	else fn:lower-case(fn:substring($t,1,1)),
	  	  	fn:lower-case(fn:substring($t,2))
	  	  ),
  	  "[^\i\c]","")
  ,"")
};
(:
  Convert Edges to Semantic Triples
:)
declare function transform:edge(
  $content,
  $context
) {
	  	object-node {
		   "edge" : xdmp:to-json(
		    sem:triple(
		       sem:iri($IRI-PREFIX || $content/node_1),
		       sem:iri($IRI-PREFIX || "rel/" || transform:camelize($content/rel_type)),
		       sem:iri($IRI-PREFIX || $content/node_2)
		    ))/node()
		}
};
(:
 : Extracts links from JSON and creates triples
:)
declare function transform:node(
  $content as map:map,
  $context as map:map
) {
	let $out := json:object()
	let $props := map:get($content,"value")/node()
	let $id := $props/node_id
	let $uri := map:get($content,"uri")
	let $type :=
		switch (fn:true())
		case fn:contains($uri,"addresses") return "Address"
		case fn:contains($uri,"entities") return "Entity"
	    case fn:contains($uri,"intermediaries") return "Intermediary"
	    case fn:contains($uri,"officers") return "Officer"		
	    default return fn:error(xs:QName("MISSING-DATA"),"Data is not in correct format")
	let $_ := 
		for $prop in $props/text()
	    let $name := fn:string(fn:node-name($prop))
		return  
		  map:put($out,$name,$prop)
	let $triples :=
	    for $prop in $props/text()
	    let $name := fn:string(fn:node-name($prop))
	    return
	        sem:triple(
	            sem:iri($IRI-PREFIX || $id),
	            sem:iri($IRI-PREFIX || transform:camelize($name)),
	            fn:data($prop)
	        )
	let $type := 
		sem:triple(
			sem:iri($IRI-PREFIX || $id),
			sem:iri($RDF-PREFIX || "type"),
			sem:iri($IRI-PREFIX || $type)
		)
    let $_ := map:put($out,"triples", ($type,$triples))
    return  
      xdmp:to-json($out)
};