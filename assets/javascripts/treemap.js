function position() {
  this.style("left", function(d) { return d.x + "px"; })
      .style("top", function(d) { return (d.y + 65) + "px"; })
      .style("width", function(d) { return Math.max(0, d.dx - 1) + "px"; })
      .style("height", function(d) { return Math.max(0, d.dy - 1) + "px"; });
}

function makeTreeMap(width, height, element, data) {
  var color = d3.scale.category20b(),
      div = d3.select(element).append("div")

  var treemap = d3.layout.treemap()
      .size([width, height])
      .sticky(true)
      .value(function(d) { return d.size; });
   
  var node = div.datum(data).selectAll(".node")
        .data(treemap.nodes)
      .enter()
      .append("a")
        .attr("href", function(d) {
          return d.url; })
        .attr("target", "_blank")
        .append("div")
          .attr("class", "node")
          .call(position)
          .style("background-color", function(d) {
              return d.name == 'tree' ? '#fff' : color(d.name); })
          .append('div')
            .style("font-size", function(d) {
              // compute font size based on sqrt(area)
              return Math.max(20, 0.1*Math.sqrt(d.area))+'px'; })
            .text(function(d) { return d.children ? null : d.name; });
}