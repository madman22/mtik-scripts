#disables the router deployment
:global DisableRouter do={
    :local output ""
    :do { /routing ospf instance set 0 disabled=yes router-id="0.0.0.0" } on-error={  :set output "Error: Cannot reset ospf instance" }
    :local output2 ""
    :local ipid
    :do { :set ipid [/ip address find comment="loopback"] } on-error={ :return ("Error: Cannot find Loopback IP ". $output) }
    if ([:len $ipid] < 1) do={
        :return ("Error: Cannot find Loopback IP ". $output)
    }
    :do { /ip address set $ipid disabled=yes } on-error={  :set output2 "Error: Cannot disable Loopback IP" }
    if ([:len $output] > 0 ) do={
        if ([:len $output2] > 0) do={
            :return ($output . " " . $output2)
        } else={
            :return $output
        }
    } else={
        if ([:len $output2] > 0) do={
            :return $output2
        }
    }
    :return ""
}
