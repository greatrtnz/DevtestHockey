<?php
/*
select game,nickname, score, country, state, city, age, gender, skill, puck, dekerbar, bands, panels 
    from SDScores
    where game ='Training' AND
        age >= 8 and age<= 12 AND  
        panels = 3 AND
        Puck = 1 AND
        dekerbar = 0 AND
        bands = 1
*/
// ../QueryScores.php/game/country/state/city/agebrack/gender/skill/puck/dekerbar/bands/panels

$method = $_SERVER['REQUEST_METHOD'];
$request = explode('/', trim($_SERVER['PATH_INFO'],'/'));
$game = filter_var(array_shift($request), FILTER_SANITIZE_STRING);
$country = trim(filter_var(array_shift($request), FILTER_SANITIZE_STRING));
$state = trim(filter_var(array_shift($request), FILTER_SANITIZE_STRING));
$city = trim(filter_var(array_shift($request), FILTER_SANITIZE_STRING));
$ageBrack = trim(filter_var(array_shift($request), FILTER_SANITIZE_STRING));
$gender = filter_var(array_shift($request), FILTER_SANITIZE_STRING);
$skill = trim(filter_var(array_shift($request), FILTER_SANITIZE_STRING));
$puck = filter_var(array_shift($request), FILTER_SANITIZE_STRING);
$dekerbar = filter_var(array_shift($request), FILTER_SANITIZE_NUMBER_INT);
$bands = filter_var(array_shift($request), FILTER_SANITIZE_NUMBER_INT);
$panels = filter_var(array_shift($request), FILTER_SANITIZE_NUMBER_INT);


//echo 'Nick is :'.$nick.'<br>';
//echo 'DCType es :'.$dctype.'<br>';
//echo 'Sello es :'.$sello.'<br>';

if ($game==''){
	header('Cache-Control: no-cache, must-revalidate');
    header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
    // headers to tell that result is JSON
    header('Content-type: application/json');
    echo '{"result":"ErrGame","ret":[]}';
	exit;
}
if ($country=='' && $state!='' ){
	header('Cache-Control: no-cache, must-revalidate');
    header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
    // headers to tell that result is JSON
    header('Content-type: application/json');
    echo '{"result":"ErrState","ret":[]}';
	exit;
}
if ($country=='' && $city!=''){
	header('Cache-Control: no-cache, must-revalidate');
    header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
    // headers to tell that result is JSON
    header('Content-type: application/json');
    echo '{"result":"ErrCity","ret":[]}';
	exit;
}
if ($country!='' && $state==''  && $city!=''){
	header('Cache-Control: no-cache, must-revalidate');
    header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
    // headers to tell that result is JSON
    header('Content-type: application/json');
    echo '{"result":"ErrState","ret":[]}';
	exit;
}
//echo "AgeBracket:".$ageBrack;
if ($ageBrack!=''){
    $offset = strpos($ageBrack,'>');
    $error = FALSE;
    if ($offset == FALSE){
        $error = TRUE;
    }
    $min = substr($ageBrack,0,$offset);
    //echo "Min:".$min;
    if ($min != 0){ // To avoid missinterpretting $min as false when its 0
      if ($min == FALSE || $min == '' || !is_numeric($min)){
          $error = TRUE;
          //echo "min error";
      }
    }
    $max = substr($ageBrack,$offset+1);
    //echo "Max:".$max;
    
    if ($max == FALSE || $max ==' ' || !is_numeric($max)){
        $error = TRUE;
        //echo "max error";
    }
    if ($error){
        header('Cache-Control: no-cache, must-revalidate');
        header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
        // headers to tell that result is JSON
        header('Content-type: application/json');
        echo '{"result":"ErrAgeBracket","ret":[]}';
        exit;
    }
}

switch ($gender) {
    case " ":
      //BOTH;
      //echo "BOTH";
      break;
    case "1": 
      //MALE;
      //echo "MALE";
      break;
    case "0":
      //FEMALE;
      //echo "FEMALE";
      break;
     
    default:
        header('Cache-Control: no-cache, must-revalidate');
        header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
        // headers to tell that result is JSON
        header('Content-type: application/json');
        echo '{"result":"ErrGender","ret":[]}';
        exit;
        break;
  }

  switch ($puck) {
    //case " ":
      //BOTH;
      //echo "BOTH PUCKS";
      //break;
    case "e": 
      //RUE;
      //echo "PUCK TRUE";
      break;
    case "max":
      //PUCK FALSE;
      //echo "PUCK FALSE";
      break;
    case "ball":
      //PUCK FALSE;
      //echo "PUCK FALSE";
     break;
     
    default:
        header('Cache-Control: no-cache, must-revalidate');
        header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
        // headers to tell that result is JSON
        header('Content-type: application/json');
        echo '{"result":"ErrPuck","ret":[]}';
        exit;
        break;
  }

  switch ($dekerbar) {
    //case " ":
      //BOTH;
      //echo "BOTH dekerbar";
      //break;
    case "1": 
      //TRUE;
      //echo "TRUE DEKERBAR";
      break;
    case "0":
      //FEMALE;
      //echo "FALSE DEKERBAR";
      break;
     
    default:
        header('Cache-Control: no-cache, must-revalidate');
        header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
        // headers to tell that result is JSON
        header('Content-type: application/json');
        echo '{"result":"ErrDekerBar","ret":[]}';
        exit;
        break;
  }

  switch ($bands) {
    //case " ":
      //BOTH;
      //echo "BOTH BANDS";
      //break;
    case "1": 
      //TRUE;
      //echo "TRUE BANDS";
      break;
    case "0":
      //FALSE;
      //echo "FALSE BANDS";
      break;
     
    default:
        header('Cache-Control: no-cache, must-revalidate');
        header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
        // headers to tell that result is JSON
        header('Content-type: application/json');
        echo '{"result":"ErrBands","ret":[]}';
        exit;
        break;
  }

  
//echo "Panels:".$panels;
if (!is_numeric($panels) || (is_numeric($panels) && ($panels < 1 || $panels > 5))){
    header('Cache-Control: no-cache, must-revalidate');
    header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
    // headers to tell that result is JSON
    header('Content-type: application/json');
    echo '{"result":"ErrPanels","ret":[]}';
    exit;
}

//echo 'OK para query';

//exit;

include 'dbconex.php';

$connectionInfo = array( "UID"=>$uid,                            
                         "PWD"=>$pwd,                            
                         "Database"=>$databaseName); 
  
/* Connect using SQL Server Authentication. */  
$link = sqlsrv_connect( $serverName, $connectionInfo);  
 
// create SQL based on HTTP method
	header('Cache-Control: no-cache, must-revalidate');
	header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
	// headers to tell that result is JSON
	header('Content-type: application/json');

switch ($method) {
  case 'GET':
		$sql = "select game,nickname, score, country, state, city, age, gender, skill, puck, dekerbar, bands, panels, stick, glove, videolink, when_date ";
        $sql =$sql." from SDScores ";
        $sql =$sql." where game ='".$game."' AND ";
        if ($country != ''){
          $sql =$sql." country = '".$country."' AND ";
          if ($state != ''){
            $sql =$sql." state = '".$state."' AND ";
            if ($city != ''){
              $sql =$sql." city = '".$city."' AND ";
            }
          }
        }
        $sql =$sql." panels = ".$panels." AND ";
        $sql =$sql." puck = '".$puck."' AND ";
        $sql =$sql." dekerbar = ".$dekerbar." AND ";
        $sql =$sql." bands = ".$bands;
        if ($ageBrack!=''){
            $sql =$sql." AND age >= ".$min." and age<= ".$max;
        } 
        if ($skill!=''){
            $sql =$sql." AND skill = '".$skill."'";
        }  
        if ($gender!=" "){
            $sql =$sql." AND gender = ".$gender;
        }
        $sql =$sql." ORDER BY score DESC ";


		//echo $sql;
    break;
  default:
		echo json_encode([]);
		exit;
	break;
}
// excecute SQL statement

//echo $sql;

//exit;

$result =  sqlsrv_query($link,$sql);
 
// die if SQL statement failed

if (!$result){
    //echo "No result";
    echo '{"result":"ErrResult","ret":[]}';
    //exit;
}
else{
    if (!sqlsrv_has_rows($result)){
        //echo "No rows" ;
        echo '{"result":"ErrNoRows","ret":[]}';
        //exit;
    }
    else {
        $metaData = sqlsrv_field_metadata($result);
		$numFields = sqlsrv_num_fields( $result );
		
        echo '{"result":"Ok","ret":[';
        $firsttime = true;
        while ( sqlsrv_fetch( $result )) {
        // Iterate through the fields of each row.
            if (!$firsttime){
                echo ',';
            }
            else{
                $firsttime = false;
            }
            echo '{';
            for($i = 0; $i < $numFields; $i++) { 
                if ($i != 0){
                    echo ',';
                }
                $content = mb_convert_encoding(sqlsrv_get_field($result, $i), "UTF-8", "HTML-ENTITIES");			
                echo '"'.$metaData[$i]["Name"] . '":"'.$content.'"';
            }
            echo '}';
        }
        echo ']}';
    }		
}

sqlsrv_free_stmt($result); 
sqlsrv_close($link);
 	
?>
