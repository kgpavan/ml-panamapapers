xquery version "1.0-ml";

module namespace trns = "http://marklogic.com/pp/transform/node-transform";

import module namespace transform = "http://marklogic.com/pp/transform" 
at "/main/lib/transform-library.xqy";

declare function trns:transform(
 $content as map:map,
 $context as map:map
) as map:map
{
  let $transform := transform:node($content,$context)
  let $_ := map:put($content,"value",$transform)
  return 
    $content
};
