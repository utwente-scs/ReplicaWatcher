<?php
$end_time= time() + 600;
while (time() < $end_time) {
echo "Current time: " . date('H:i:s');
}

?>
