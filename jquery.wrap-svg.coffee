# Red Brain Labs adaptation of http://stackoverflow.com/questions/3294553/jquery-selector-svg-incompatible
# Requires Javascript 1.8.5

((jQuery) ->
  createSvgWrapper = (svg_tag_name) ->
    obj = { _svgEl: null }
    for key, val of $("<svg><#{svg_tag_name}/></svg>").find("#{svg_tag_name}")[0]
      ((key) ->
        if val? && val.baseVal?
          Object.defineProperty obj, key,
            get: -> @_svgEl[key].baseVal
            set: (value) -> @_svgEl[key].baseVal = value
        else
          Object.defineProperty obj, key,
            get: -> @_svgEl[key]
            set: (value) -> @_svgEl[key] = value
      )(key)
    obj
  # some svg path and text attributes are not implemented in FireFox 15.0
  svg_tag_names = ['rect', 'circle', 'ellipse', 'line', 'polygon', 'polyline']#, 'path', 'text']
  wrap_map = {}
  wrap_map[tag_name] = createSvgWrapper tag_name for tag_name in svg_tag_names

  svgWrapper = (el) ->
    @_svgEl = el
    @__proto__ = wrap_map[el.tagName]
    @

  jQuery.fn.wrapSvg = ->
    @map (i, el) ->
      if el.namespaceURI is "http://www.w3.org/2000/svg" and ("_svgEl" not of el)
        new svgWrapper(el)
      else
        el

)(window.jQuery)
