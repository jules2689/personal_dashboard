class Dashing.TreeMap extends Dashing.Widget
  ready: ->
    tree = { name: @get("name"), children: @get("children") }
    makeTreeMap(@get("width"), @get("height"), @node.getElementsByClassName('treeMap')[0], tree)
