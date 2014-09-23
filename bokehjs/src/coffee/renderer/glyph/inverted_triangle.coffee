define [
  "underscore",
  "renderer/properties",
  "./marker",
], (_, Properties, Marker) ->

  class InvertedTriangleView extends Marker.View

    _fields: ['x', 'y', 'size']
    _properties: ['line', 'fill']

    _render: (ctx, indices, glyph_props, sx=@sx, sy=@sy, size=@size) ->
      for i in indices

        if isNaN(sx[i] + sy[i] + size[i])
          continue

        a = size[i] * Math.sqrt(3)/6
        r = size[i]/2
        h = size[i] * Math.sqrt(3)/2
        ctx.beginPath()
        # TODO use viewstate to take y-axis inversion into account
        ctx.moveTo(sx[i]-r, sy[i]-a)
        ctx.lineTo(sx[i]+r, sy[i]-a)
        ctx.lineTo(sx[i],   sy[i]-a+h)
        ctx.closePath()

        if glyph_props.fill_properties.do_fill
          glyph_props.fill_properties.set_vectorize(ctx, i)
          ctx.fill()

        if glyph_props.line_properties.do_stroke
          glyph_props.line_properties.set_vectorize(ctx, i)
          ctx.stroke()

  class InvertedTriangle extends Marker.Model
    default_view: InvertedTriangleView
    type: 'InvertedTriangle'

    display_defaults: ->
      return _.extend {}, super(), @line_defaults, @fill_defaults

  class InvertedTriangles extends Marker.Collection
    model: InvertedTriangle

  return {
    Model: InvertedTriangle
    View: InvertedTriangleView
    Collection: new InvertedTriangles()
  }
