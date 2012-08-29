<?php
if (!isset($argv[1]) && !isset($_GET['find']))
{
    die("Argument needs to be a valid hostname.\n");
}

$lookupArr = array("direct-connect.");

foreach ($lookupArr as $lookupKey)
{

    if (isset($_GET['find']))
    {
        $newline = "<br />";
        $lookupHost = $lookupKey . $_GET['find'];
    }
    else
    {
        $newline = "\n";
        $lookupHost = $lookupKey . $argv[1];
    }

    $foundHost = gethostbyname($lookupHost);

    if ($foundHost == $lookupHost)
    {
        //echo "{$lookupHost} had no DNS record.";
    }
    else
    {
		echo "{$foundHost}";
    }
}
?>