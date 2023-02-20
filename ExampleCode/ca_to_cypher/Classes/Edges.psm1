class BasicEdge {
    [string]$Relationship
    [string]$Source
    [string]$Target

    BasicEdge(){}
    
    BasicEdge( 
        [string]$Relationship,
        [string]$Source,
        [string]$Target
    ) {
        $this.Relationship = $Relationship
        $this.Source = $Source
        $this.Target = $Target
    }
}