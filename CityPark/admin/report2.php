<?php

include("cache.php");
$Cache = new CacheBlocks("cache/", 86400);
if(!$fulljs = $Cache->Load("cache".$_SERVER['HTTP_HOST'])){

include('gapi.class.php');



  
function getASPSessionVariable($variable_name)
{
$var_data = file_get_contents("http://".$_SERVER['HTTP_HOST']."/get_asp_a94kf8ax82ma-918zm5c.asp?ses=" . $variable_name);
return $var_data;
}

function getAspConf($variable_name)
{
$var_data = file_get_contents("http://".$_SERVER['HTTP_HOST']."/get_asp_a94kf8ax82ma-918zm5c.asp?conf=" . $variable_name);
return $var_data;
}
	
function js_escape($text) {
	$text = wp_specialchars($text, 'double');
	$text = str_replace('&#039;', "'", $text);
	return preg_replace("/\r?\n/", "\\n", addslashes($text));
}

function wp_specialchars( $text, $quotes = 0 ) {
    // Like htmlspecialchars except don't double-encode HTML entities
    $text = preg_replace('/&([^#])(?![a-z1-4]{1,8};)/', '&#038;$1', $text);
    $text = str_replace('<', '&lt;', $text);
    $text = str_replace('>', '&gt;', $text);
    if ( 'double' === $quotes ) {
	    $text = str_replace('"', '&quot;', $text);
    } elseif ( 'single' === $quotes ) {
    	$text = str_replace("'", '&#039;', $text);
    } elseif ( $quotes ) {
        $text = str_replace('"', '&quot;', $text);
        $text = str_replace("'", '&#039;', $text);
    }
	return $text;
}

define('ga_email',getAspConf("Analyticsusername")); 

define('ga_password',getAspConf("Analyticspassword")); 

define('ga_profile_id',getAspConf("Analyticssiteid"));


//start analytics
$ga = new gapi(ga_email,ga_password);
	$dimensions=array('date');
	$metrics=array('visitors','newVisits','visits','pageviews','timeOnPage','bounces','entrances','exits');
	$fulljs = "";
	$errormsg = "none";
	$start_date=date('Y-m-d',strtotime('-1 month -1 day'));
	$end_date=date('Y-m-d',strtotime('-1 day'));
	$records=$ga->requestReportData(ga_profile_id,$dimensions, $metrics,array('-date'),null,$start_date,$end_date);


	$fulljs = $fulljs. "{\"visits\":[";
	$row = 1;
	foreach($ga->getResults() as $result):
		$js .= '{sum:\''.$result->getVisits().'\'},';
		$row ++;
	endforeach;
	$js .=",";
	$js = str_replace(",,","",$js);
	$fulljs = $fulljs. $js."]";


$gas = new gapi(ga_email,ga_password);
	$dimensions=array('source');
	$metrics=array('visits');
	$gas->requestReportData(ga_profile_id,$dimensions,$metrics,array('-visits'),null,$start_date,$end_date,1,6);
	$fulljs = $fulljs. ",pie:[";
	foreach($gas->getResults() as $result):
		$script .= "{name:'".js_escape($result->getSource())."',val:'".$result->getVisits()."'},"; //"-".$result->getVisits().
	endforeach;
	$script .=",";
	$script = str_replace(",,","",$script);
	$fulljs = $fulljs. $script."]";
	
	//echo $fulljs;
	
$script = "";
	$dimensions=array('country');
	$metrics=array('visits');
	$gamap = new gapi(ga_email,ga_password);
	$gamap->requestReportData(ga_profile_id,$dimensions,$metrics,array('-visits'),null,$start_date,$end_date);
	$fulljs = $fulljs. ",map:[{count:'".count($gamap->getResults())."'},{countries:[";
		foreach($gamap->getResults() as $result):
			$script .= "{name:'".js_escape($result->getCountry())."',val:'".$result->getVisits()."'},";
		endforeach;
		$script .=",";
$script = str_replace(",,","",$script);
$fulljs = $fulljs. $script;
	$fulljs = $fulljs. "]}";
	$fulljs = $fulljs. "]";
$script = "";
	$gak = new gapi(ga_email,ga_password);
	$dimensions=array('keyword');
	$metrics=array('visits');
	$gak->requestReportData(ga_profile_id,$dimensions,$metrics,array('-visits'),null,$start_date,$end_date,1,10);
	$fulljs = $fulljs. ",keywords:[{count:'".count($gak->getResults())."'},{words:[";
	foreach($gak->getResults() as $result):
		$script .= "{word:'".js_escape($result->getKeyword())."',val:'".$result->getVisits()."'},";
	endforeach;
	$script .=",";
	$script = str_replace(",,","",$script);
	$fulljs = $fulljs. $script;
	$fulljs = $fulljs. "]}";
	$fulljs = $fulljs. "]";
	

$script = "";
	$pak = new gapi(ga_email,ga_password);
	$dimensions=array('pagePath');
	$metrics=array('pageviews');
	$pak->requestReportData(ga_profile_id,$dimensions,$metrics,array('-pageviews'),null,$start_date,$end_date,1,10);
	//print_r($pak);
	$fulljs = $fulljs. ",pages:[";
	foreach($pak->getResults() as $result):
		$script .= "{name:'".js_escape($result->getpagePath())."',val:'".$result->getPageviews()."'},";
	endforeach;
	$script .=",";
	$script = str_replace(",,","",$script);
	$fulljs = $fulljs. $script;
	$fulljs = $fulljs. "]";

	
$fulljs = $fulljs. "}";
  $Cache->Save($fulljs, "cache".$_SERVER['HTTP_HOST']);
}
//{"visits":[{sum:'345'},{sum:'699'},{sum:'198'},{sum:'232'},{sum:'399'},{sum:'359'},{sum:'259'},{sum:'401'},{sum:'613'},{sum:'187'},{sum:'142'},{sum:'163'},{sum:'227'},{sum:'255'},{sum:'510'},{sum:'215'},{sum:'90'},{sum:'233'},{sum:'309'},{sum:'283'},{sum:'256'},{sum:'290'},{sum:'1569'},{sum:'168'},{sum:'124'},{sum:'141'},{sum:'226'},{sum:'91'},{sum:'165'},{sum:'192'}],pie:[{name:'direct',sum:'80'},{name:'reffer',sum:'12'},{name:'search engin',sum:'8'}],map:[{count:'30'},{countries:[{name:'Israel',val:'8739'},{name:'United States',val:'173'},{name:'United Kingdom',val:'57'},{name:'(not set)',val:'49'},{name:'Zambia',val:'47'},{name:'Italy',val:'36'},{name:'Canada',val:'31'},{name:'Romania',val:'31'},{name:'Luxembourg',val:'24'},{name:'Thailand',val:'23'},{name:'Russia',val:'22'},{name:'Taiwan',val:'22'},{name:'Denmark',val:'21'},{name:'Germany',val:'21'},{name:'Argentina',val:'17'},{name:'Spain',val:'16'},{name:'Nigeria',val:'14'},{name:'Czech Republic',val:'13'},{name:'Netherlands',val:'13'},{name:'Sweden',val:'12'},{name:'Greece',val:'11'},{name:'Hungary',val:'11'},{name:'Poland',val:'11'},{name:'Brazil',val:'10'},{name:'Ireland',val:'10'},{name:'Mexico',val:'10'},{name:'France',val:'8'},{name:'Moldova',val:'8'},{name:'Singapore',val:'7'},{name:'Malaysia',val:'6'}]}]} 
echo $fulljs;
?>
