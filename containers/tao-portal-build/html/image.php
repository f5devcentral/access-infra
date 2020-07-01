<?php
  // Get title import
  $title= urldecode($_GET['title']);

  // Variables for Text Rendering
  $len = 17;                     // Per row string total length   
  $pad = 21;                     // Per row padded string total length 
  $row_height = 120;             // Row Height 
  $num_rows = 6;                 // Number of rendered rows allowed 
  $cordX = 280;                  // Left margin of textbox (based on image)  
  $font_size = 100;              // Font size of text
  $font = './fonts/calibri.ttf'; // Assigned Font      
  $angle = 0;                    // Angle of text 
  $top_margin = 140;             // Top magin of textbox (based on image)
 
  // Begin Image formatting
  header('Content-Type: image/jpeg');
  $im = imagecreatefromjpeg('./img/sme-ua-bg-min.jpg');
  $shadow = imagecolorallocate($im, 128, 128, 128);
  $color = imagecolorallocate($im, 60, 91, 116);

  // Render Text
  $title_len = strlen($title);
  if ( $title_len != 0) {
    $words = explode(' ', $title);
    $row_id = 0;
    foreach ($words as $key => $value) {
      if ( ($row_id <= $num_rows) && (strlen($value) < $len) ) {
        if ( (strlen($output[$row_id]) + strlen($value)) <= $len) {
          $output[$row_id] = $output[$row_id].$value." ";
        } else {
          $row_id++;
          $output[$row_id] = $value." ";
        }
      } else {
        $ouput = array();
        $output[0] = "Title too long";
        break;
      }
    }
  } else { 
    $output[0] = "Missing Title";
  }  

  // Caulculate Starting Y Position
  $empty_rows = $num_rows-count($output);
  if ( $empty_rows >= 5) {
    $cordY = $top_margin + ($row_height*3); 
  } else {
    $cordY = $top_margin + (round($empty_rows/2, 0, PHP_ROUND_HALF_UP)*$row_height);
  }

  // Output Text Rows
  foreach ($output as $key => $value) {
    $row = str_pad(trim($value), $pad, ' ', STR_PAD_BOTH);
    imagettftext($im, $font_size, $angle, $cordX+2,  $cordY+2, $shadow, $font, $row); //shadow
    imagettftext($im, $font_size, $angle, $cordX, $cordY, $color, $font, $row); // text
    $cordY = $cordY + $row_height;
  }
 
  // Output Image
  imagejpeg($im);
  imagedestroy($im);

?>