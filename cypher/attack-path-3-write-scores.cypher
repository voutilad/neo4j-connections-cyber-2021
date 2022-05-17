// Attack Path 3 - Write  Scores
CALL gds.betweenness.write("attack-paths", {
  writeProperty: "betweennessScore"
})
