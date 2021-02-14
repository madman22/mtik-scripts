# :put [$ExtractIP ip="10.1.1.1"]
:global ExtractIP do={
    :local ipaddr [:toip $ip]
    if ([:typeof $ipaddr] = "ip") do={
        :return [:tostr $ipaddr]
    } else={
        :global ExtractIPFromRange
        :return [$ExtractIPFromRange]
    }
}

# :put [$ExtractIPFromRange ip="10.1.1.1/24"]
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

# :put [$ExtractPrefix ip="10.1.1.1/24"]
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

# :put [$VerifyRange ip="10.1.1.1/24"]
# maybe check valid ip and add /32
:global VerifyRange do={
    :local iprange ([[:parse ":return $ip"]])
    if ([:typeof $iprange] = "ip-prefix") do={
        :return [:tostr $iprange]
    } else={
        :return "error"
    }
}

# :put [$VerifyIP ip="10.1.1.1/24"]
# :put [$VerifyIP ip="10.1.1.1"]
:global VerifyIP do={
    :local ipaddr [:toip $ip]
    if ([:typeof $ipaddr] = "ip") do={
        :return [:tostr $ipaddr]
    } else={
        :global VerifyRange
        :return [$VerifyRange ip=$ip]
    }
}

#disables the router deployment
:global DisableRouter do={
    :local output ""
    :do { /routing ospf instance set 0 disabled=yes router-id="0.0.0.0" } on-error={  :set output "Error: Cannot reset ospf instance" }
    :do { /ip address set [find comment="loopback"] disabled=yes } on-error={  :set output "Error: Cannot disable Loopback IP" }
    :return $output
}
