
:global ExtractIP do={
    :local ipaddr [:toip $ip]
    if ([:typeof $ipaddr] = "ip") do={
        :return [:tostr $ipaddr]
    } else={
        :global ExtractIPFromRange
        :return [$ExtractIPFromRange]
    }
}

:global ExtractIPFromRange do={
    :local idpos [:find $ip "/"]
    if ($idpos < 1) do={
        :return "error not a subnet, too short"
    }
    if ($idpos > [:len $ip]) do={
        :return "error not a subnet, too long"
    }
    :local extracted [:pick $ip 0 $idpos]
    if ([:len $extracted] < 3) do={
        :return ("error no subnet: " . $extracted)
    } else={
        :return $extracted
    }
}

:global ExtractPrefix do={
    :local idpos [:find $ip "/"]
    if ($idpos >= [:len $ip]) do={
        :return "error"
    }
    :local extracted [:pick $ip $idpos [len $ip]]
    if ([:len $extracted] != 3) do={
        :return "error"
    } else={
        :return $extracted
    }
}
