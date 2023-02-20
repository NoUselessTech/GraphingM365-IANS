Function Export-Node {
    Param(
        $Nodes,
        $Method
    )

    If ($Nodes.count -gt 0) {
        # Output string for the final file.
        $Output = "CREATE"

        # Filter through the nodes.
        ForEach($Node in $Nodes) {
            $Label = $Node.Type
            $Values = $Node | ConvertTo-Json -Compress 
            # Format it so that Neo doesn't get mad
            # # This one removes the quotes around the property label
            $Values = $Values -replace '"(\w*)":', '$1:'
            $Output += " (:$Label $Values),"
        }

        $Output = $Output.Substring(0,$Output.length-1)
        $Output += ";"

        # Write the output
        if ($Method -eq "Append") {
            $Output | Out-File -Append ".\Output\GraphData.cypher"
        } else {
            $Output | Out-File ".\Output\GraphData.cypher"
        }
    }

    return $True
}

Function Export-Edge {
    Param(
        $Edges,
        $Method
    )

    if ($Edges.Count -gt 0) {
    
        # Output string for the final file.
        $Output = ""

        # Filter through the nodes.
        ForEach($Edge in $Edges) {
            $Label = $Edge.Relationship
            $Values = $Edge | ConvertTo-Json -Compress 
            # Format it so that Neo doesn't get mad
            # # This one removes the quotes around the property label
            $Values = $Values -replace '"(\w*)":', '$1:'

            $Output += "MATCH (n {Id:`"$($Edge.Source)`"}) "
            $Output += "MATCH (x {Id:`"$($Edge.Target)`"}) "
            $Output += "CREATE (n)-[:$Label]->(x);"
        }

        # Write the output
        if ($Method -eq "Append") {
            $Output | Out-File -Append ".\Output\GraphData.cypher"
        } else {
            $Output | Out-File ".\Output\GraphData.cypher"
        }
    }

    return $True
}

Function Export-EdgeByDisplayName {
    Param(
        $Edges,
        $Method
    )
 
    # Output string for the final file.
    $Output = ""

    # Filter through the nodes.
    ForEach($Edge in $Edges) {
        $Label = $Edge.Relationship
        $Values = $Edge | ConvertTo-Json -Compress 
        # Format it so that Neo doesn't get mad
        # # This one removes the quotes around the property label
        $Values = $Values -replace '"(\w*)":', '$1:'

        $Output += "MATCH (n {DisplayName:`"$($Edge.Source)`"}) "
        $Output += "MATCH (x {DisplayName:`"$($Edge.Target)`"}) "
        $Output += "CREATE (n)-[:$Label]->(x);"
    }

    # Write the output
    if ($Method -eq "Append") {
        $Output | Out-File -Append ".\Output\GraphData.cypher"
    } else {
        $Output | Out-File ".\Output\GraphData.cypher"
    }

    return $True
}

Function Append-CleanUp {
    $Output = ""

    $Output += "MATCH (u)-[a:Enforces]->(b)<-[s:NotEnforces]-(u) DELETE a;"

    # Write the output
    if ($Method -eq "Append") {
        $Output | Out-File -Append ".\Output\GraphData.cypher"
    } else {
        $Output | Out-File ".\Output\GraphData.cypher"
    }
}