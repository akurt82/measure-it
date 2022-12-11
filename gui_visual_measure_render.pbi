#mexsize = 12

UsePNGImageDecoder()

Macro getImg( picsource, path, label )

  CatchImage( picsource, ?label )

  DataSection
    label: IncludeBinary path
  EndDataSection

EndMacro

Global __ratio_data_x.l, __ratio_data_y.l

Procedure.l __image_ratio(photo.l,width.l,height.l)

  If Not IsImage( photo ) : ProcedureReturn -1 : EndIf

  xx.f=ImageWidth(photo)
  yy.f=ImageHeight(photo)

  If xx>width
    fix.f=width/xx
    xx*fix
    yy*fix
  EndIf
  If yy>height
    fix.f=height/yy
    xx*fix
    yy*fix
  EndIf
  
  __ratio_data_x = xx : __ratio_data_y = yy

EndProcedure

Procedure.l ratioWidth(img.l,w.l,h.l)

  __image_ratio( img, w, h )
  
  ProcedureReturn __ratio_data_x
 
EndProcedure

Procedure.l ratioHeight(img.l,w.l,h.l)

  __image_ratio( img, w, h )
  
  ProcedureReturn __ratio_data_y
 
EndProcedure

Procedure resimratio( img.u )
  If IsImage(img)
    __image_ratio( img, 16, 16 )
    ; ***
    ResizeImage( img, __ratio_data_x, __ratio_data_y )
  EndIf
EndProcedure

Procedure.s pick( index.l, char.s, value.s )
  Protected n.l, s.s, idx.l = 0
  ; ***
  For n = 1 To Len( value )
    Select Mid( value, n, 1 )
      Case char
        If idx = index
          Break
        Else
          idx + 1
          ; ***
          s = ""
        EndIf
      Default
        s + Mid( value, n, 1 )
    EndSelect
  Next
  ; ***
  If idx > index
    s = ""
  EndIf
  ; ***
  If index < 0
    s = ""
  EndIf
  ; ***
  If index > CountString( value, char )
    s = ""
  EndIf
  ; ***
  ProcedureReturn s
EndProcedure

Procedure __plot( x, y, color.l, outlined.a = 0 )
  If OutputWidth() And OutputHeight()
    If x >= 0 And x < OutputWidth() And y >= 0 And y < OutputHeight()
      Plot( x, y, color )
    EndIf
  EndIf
EndProcedure

Procedure paintCircle(x, y, radius, color.l, part.a = 0, outlined.a = 0)
  Protected r=radius+1 ;/ Radius does not include the center pixel
  Protected d=r*2 ;/ Diameter : (r<<1)
  Protected rr=r*r ;/ r^2
  Protected xi, yi ;/ Integer 0 to r along x / y
  Protected dx, dy ;/ Delta x / y for pythagorean (xi - r)^2 and (yi - r)^2
  Protected dcx2, dcy2 ;/ Delta from center axis * 2
  Protected centerX=r
  Protected centerY=r
  Protected threshold.f ;/ Smooth the last pixel along the radius
  Protected circleflag.a = 0, yyy = -1, xxx = -1, pointed.a = 0
  
  threshold.f=1
  
  ;/ Manually tweak threshold for small circles
  Select radius
  Case 1
    Plot(1,0,color)
    Plot(0,1,color)
    Plot(1,1,color)
    Plot(2,1,color)
    Plot(1,2,color)
    
    ProcedureReturn
;   Case 4
;     threshold.f=0.75
;   Case 5, 13
;     threshold.f=0.9
;   Case 6, 7, 8
;     threshold.f=0.88
;   Case 16, 17
;     threshold.f=0.93
;   Case 21
;     threshold.f=0.94
;   Case 22, 23, 24, 25, 26, 27
;     threshold.f=0.95
;   Case 28
;     threshold.f=0.96
;   Case 29, 30
;     threshold.f=0.9623
;   Case 33
;     threshold.f=0.965
;   Case 37
;     threshold.f=0.983
;   Default
    threshold.f=1-1.0/r
  EndSelect
  
  ;/ The circle is shifted -1 along x and y to account for
  ;/ a single pixel appearing at each pole. The pixel is
  ;/ accounted for by dx+dy '<' rr instead of '<='
  ;/ to by drawing pixels which are within the radius but
  ;/ not those which lay on it exactly.
  x-1
  y-1
  
  For yi=0 To r
    dy=(r-yi)*(r-yi)
    dcy2=(centerY-yi)*2

    pointed = 0

    For xi=0 To r
      dx=(r-xi)*(r-xi)
      
      ;/ Point is on or outside the circle
      If Not dx+dy<rr
        Continue
      EndIf
      
      ;/ Distance from center 0-1
      distance.f=(dx+dy)/rr
      
      ;/ Edge threshold (smoothing)
      If distance.f>threshold.f
        Continue
      EndIf

      dcx2=(centerX-xi)*2

      If outlined = 1
        If yyy <> y + yi
          yyy = y + yi
          ; ***
          circleflag = 0
        Else
          Select pointed
            Case 0 To 9
              If yyy < y + 3 Or yyy > y + d - 3
                circleflag = 0
                pointed + 1
              Else
                circleflag = 1
              EndIf
            Default
              If yi < 2 Or yi > r - 2
                circleflag = 0
              Else
                circleflag = 1
              EndIf
          EndSelect
        EndIf
      EndIf

      If circleflag = 0
        Select part
          Case 0 ; Full
            ;/ Vertical axis
            If centerX=xi
              __Plot(x+xi,y+yi,color, outlined)
              __Plot(x+xi,y+yi+dcy2,color, outlined)
            ;/ Horizontal axis  
            ElseIf centerY=yi
              __Plot(x+xi,y+yi,color, outlined)
              __Plot(x+xi+dcx2,y+yi,color, outlined)
            Else
              ; Top left quadrant
              __Plot(x+xi,y+yi,color, outlined)
              
              ;/ Top right quadrant
              __Plot(x+xi+dcx2,y+yi,color, outlined)
              
              ;/ Buttom left quadrant
              __Plot(x+xi,y+yi+dcy2,color, outlined)
              
              ;/ Bottom right quadrant
              __Plot(x+xi+dcx2,y+yi+dcy2,color, outlined)
            EndIf
          Case 1 ; Oberhalb
            ;/ Vertical axis
            If centerX=xi
              __Plot(x+xi,y+yi,color, outlined)
            ElseIf centerY=yi
              __Plot(x+xi,y+yi,color, outlined)
              __Plot(x+xi+dcx2,y+yi,color, outlined)
            Else
              ; Top left quadrant
              __Plot(x+xi,y+yi,color, outlined)
              
              ;/ Top right quadrant
              __Plot(x+xi+dcx2,y+yi,color, outlined)
            EndIf
          Case 2 ; Unterhalb
            ;/ Vertical axis
            If centerX=xi
              __Plot(x+xi,y+yi+dcy2,color, outlined)
            ;/ Horizontal axis  
            ElseIf centerY=yi
              __Plot(x+xi,y+yi,color)
              __Plot(x+xi+dcx2,y+yi,color, outlined)
            Else
              ;/ Buttom left quadrant
              __Plot(x+xi,y+yi+dcy2,color, outlined)
              
              ;/ Bottom right quadrant
              __Plot(x+xi+dcx2,y+yi+dcy2,color, outlined)
            EndIf
          Case 3 ; Links
            ;/ Vertical axis
            If centerX=xi
              __Plot(x+xi,y+yi,color, outlined)
              __Plot(x+xi,y+yi+dcy2,color, outlined)
            ;/ Horizontal axis  
            ElseIf centerY=yi
              __Plot(x+xi,y+yi,color, outlined)
            Else
              ; Top left quadrant
              __Plot(x+xi,y+yi,color, outlined)
              
              ;/ Buttom left quadrant
              __Plot(x+xi,y+yi+dcy2,color, outlined)
            EndIf
          Case 4 ; Rechts
            ;/ Vertical axis
            If centerX=xi
              __Plot(x+xi,y+yi,color, outlined)
              __Plot(x+xi,y+yi+dcy2,color, outlined)
            ;/ Horizontal axis  
            ElseIf centerY=yi
              __Plot(x+xi+dcx2,y+yi,color, outlined)
            Else
              ;/ Top right quadrant
              __Plot(x+xi+dcx2,y+yi,color, outlined)
              
              ;/ Bottom right quadrant
              __Plot(x+xi+dcx2,y+yi+dcy2,color, outlined)
            EndIf
          Case 5 ; Oben Links, unten Rechts
          Case 6 ; Oben Rechts, unten Links
        EndSelect
      EndIf

    Next xi
  Next yi
EndProcedure

Procedure drawHalfCircle(px.w, py.w, r.i, mode.a, color.l)

    ; Consider a rectangle of size N*N
    Protected N.i = 2*r+1;
 
    Protected i.i, j.i, x.i, y.i;  ; Coordinates inside the rectangle
    Protected w.w = 0, h.w = 0
 
    ; Draw a square of size N*N.
    For i = 0 To N - 1
      w = 0
      ; ***
      For j = 0 To N - 1
        ; Start from the left most corner point
        x = i-r;
        y = j-r;
        ; If this point is inside the circle, print it
        If x*x + y*y <= r*r+1 And px + w >= 0 And px + w < OutputWidth() And py + h >= 0 And py + h < OutputHeight()
          Select mode
            Case 0
              If w < r
                Plot(px + w, py + h, color )
              EndIf
            Case 1
              If w >= r
                Plot(px + w, py + h, color )
              EndIf
            Case 2
              If h < r
                Plot(px + w, py + h, color )
              EndIf
            Case 3
              If h >= r
                Plot(px + w, py + h, color )
              EndIf
            Case 4
              If w < r And h < r
                Plot(px + w, py + h, color )
              EndIf
            Case 5
              If w < r And h >= r
                Plot(px + w, py + h, color )
              EndIf
            Case 6
              If w >= r And h < r
                Plot(px + w, py + h, color )
              EndIf
            Case 7
              If w >= r And h >= r
                Plot(px + w, py + h, color )
              EndIf
          EndSelect
        EndIf
        ; ***
        w + 1
      Next
      ; ***
      h + 1
   Next

EndProcedure

getIMG( 1500, "icons/straight_arrow_up_left.png", __a__0__ )
resimratio( 1500 )
getIMG( 1501, "icons/straight_arrow_up_right.png", __a__1__ )
resimratio( 1501 )
getIMG( 1502, "icons/straight_arrow_down_left.png", __a__2__ )
resimratio( 1502 )
getIMG( 1503, "icons/straight_arrow_down_right.png", __a__3__ )
resimratio( 1503 )
getIMG( 1504, "icons/straight_arrow_up.png", __a__4__ )
resimratio( 1504 )
getIMG( 1505, "icons/straight_arrow_down.png", __a__5__ )
resimratio( 1505 )
getIMG( 1506, "icons/straight_arrow_left.png", __a__6__ )
resimratio( 1506 )
getIMG( 1507, "icons/straight_arrow_right.png", __a__7__ )
resimratio( 1507 )
getIMG( 1508, "icons/lock.png", __a__8__ )
; 1509 verwende ich für EXPORT unter MeasureIt.pb

Prototype gui_visual_measure_callback( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Prototype gui_visual_measure_item_callback( *obj, mode.a )
Prototype gui_visual_measure_area_callback( mode.a )

Structure gui_visual_measure_item_struct
  type.a
  pic.u
  deleted.a
  axex.w
  axey.w
  hidden.a
  autosize.a
  measure.a
  showlabel.a
  lock.a ; Wenn True, kann das Element weder bewegt, noch skaliert werden
  x.f : y.f : w.f : h.f
  etop.a : ebottom.a : eleft.a : eright.a
  edlock.a : x1.w : x2.w : y1.w : y2.w
  label.s
  notice.s 
  proc.gui_visual_measure_callback
EndStructure

Structure gui_visual_measure_render_struct
  zoom.b
  pixelresize.a
  id.u
  rid.u ; Identifikation des Renders im Objekt
  numbering.w[2]
  temptext.s
  img_back.u : flag_back.a
  img_rest.u : flag_rest.a
  img_this.u
  img_sele.u : flag_sele.a
  img_temp.u
  pixw.w
  pixh.w
  fid.u
  index.w
  measurevalue.a
  measure.s
  viewmode.a
  fx.w : fy.w : sx.w : sy.w
  x1.w : x2.w : y1.w : y2.w
  cx.w : cy.w : cw.w : ch.w
  mx.w : my.w : mw.w : mh.w
  ax.w : ay.w
  px.w : py.w
  edgex1.w
  edgey1.w
  edgex2.w
  edgey2.w
  measurec.a
  measurex.w[4]
  measurey.w[4]
  rex.w[9]
  rey.w[9]
  resizing.a
  clicked.a
  moving.a
  deleted.a
  color_grid.l
  color_back.l
  color_text.l
  color_selb.l
  color_selm.l
  floor.s ; Geschoss
  sepunit.a ; Separierte Einheit
  theunit.s ; Welche Einheit
  sepflat.a ; Einliegerwohnung
  cb_item.gui_visual_measure_item_callback
  cb_area.gui_visual_measure_area_callback
  List items.gui_visual_measure_item_struct()
EndStructure

Structure gui_visual_measure_object_struct
  path.s ; Pfad der Datei
  object.s ; Objektname
  order.s
  address.s
  postalcode.s
  town.s
  deadline.s
  notice.s
  List items.gui_visual_measure_render_struct()
EndStructure

Global _guivmr_1.u = 2
Global _guivmr_2.u = 3
Global _guivmr_3.u = 3



Global *gui_virtual_measure_render_active_field.gui_visual_measure_render_struct = 0






Global free_scalable_item_mode.a = 0
Global free_scalable_item_edit.a = 0
Global free_scalable_item_proc.gui_visual_measure_callback = 0
Global free_scalable_item_data.gui_visual_measure_item_struct

Declare element_quader( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_quader_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_kreis( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_ellipse( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_ellipse_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_ellipse_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_quader_90d( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_dreieck_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_dreieck_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_dreieck_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_dreieck_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_dreieck_5( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_dreieck_6( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_dreieck_7( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_dreieck_8( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_teil_raute_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_teil_raute_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_teil_raute_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_teil_raute_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_voll_raute_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_voll_raute_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_viertel_raute_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_viertel_raute_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_halb_raute_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_halb_raute_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_halb_raute_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_halb_raute_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_sechseck_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_sechseck_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_fenster_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_fenster_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_fenster_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_fenster_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_pfeil_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_pfeil_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_pfeil_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_pfeil_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_text( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_number_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_number_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_5( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_6( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_7( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_8( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_9( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_10( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_11( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_12( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_13( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_14( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_15( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_16( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_17( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_18( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_19( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_20( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_21( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_22( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_23( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_24( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_25( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_26( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_27( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_28( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_29( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_30( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_31( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_32( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_33( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_34( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_35( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_36( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_37( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_38( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_39( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_40( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_41( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_42( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_43( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_44( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_45( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_46( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_47( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_treppe_48( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_door_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_door_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_door_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_door_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_door_5( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_door_6( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_door_7( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_door_8( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_door_9( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_door_10( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_door_11( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_door_12( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_door_13( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_door_14( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_door_15( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_aufzug_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_aufzug_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_aufzug_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_aufzug_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_kamin( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_stuetze_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_stuetze_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_stuetze_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_stuetze_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_flaster( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_dline( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_hline( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_vline( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_arrow_up( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_arrow_down( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_arrow_left( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_arrow_right( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_arrow_up_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_arrow_down_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_arrow_left_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_arrow_right_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_wand_v_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_wand_v_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_wand_v_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_wand_h_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_wand_h_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_wand_h_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_mseinheit_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_mseinheit_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_mseinheit_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_mseinheit_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_mseinheit_5( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_mseinheit_6( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_mseinheit_7( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_mseinheit_8( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_mseinheit_9( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_dachshregen_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_dachshregen_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_dachshregen_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
Declare element_dachshregen_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )

Global __preset_x1.l, __preset_x2.l, __preset_y1.l, __preset_y2.l

Global gvmr_copied_entry.gui_visual_measure_item_struct
Global gvmr_copied_draft.gui_visual_measure_render_struct

Procedure add_new_object_unit( *intance.gui_visual_measure_object_struct, floor.s, sepunit.a, theunit.s, sepflat.a )
  If *intance
    With *intance
      If ListSize(\items())
        LastElement( \items() )
      EndIf
      ; ***
      AddElement( \items() )
      ; ***
      \items()\floor = floor
      \items()\sepunit = sepunit
      \items()\theunit = theunit
      \items()\sepflat = sepflat
      \items()\deleted = 0
      ; ***
      ClearList( \items()\items() )
    EndWith
  EndIf
EndProcedure



Procedure _guivmr_eline(start_x,start_y,end_x,end_y,whatcolor,thickness)
 
err_x = 0 : err_y = 0 : inc_x = 0 : inc_y = 0

     delta_x = end_x - start_x;
     delta_y = end_y - start_y;
 

If(delta_x > 0) :inc_x = 1:ElseIf (delta_x = 0) :inc_x = 0: Else :inc_x = -1:EndIf  
If(delta_y > 0) :inc_y = 1:ElseIf (delta_y = 0) :inc_y = 0: Else :inc_y = -1:EndIf          
      
     delta_x = Abs(delta_x);
     delta_y = Abs(delta_y);
     
     If(delta_x > delta_y) 
       distance = delta_x;
     Else 
       distance = delta_y;
     EndIf  
     
     For  xyz = 0 To  distance+1 Step 1
       
       ; modified to place a circle at the pixel location to get a thick line
          
          ;Plot(start_x,start_y,whatcolor)     
          Circle(start_x,start_y,thickness,whatcolor)     

          err_x = err_x + delta_x
          err_y = err_y + delta_y
          
          If (err_x > distance)
              err_x = err_x - distance
              start_x = start_x + inc_x
            EndIf

           If (err_y > distance)
             err_y = err_y - distance
             start_y = start_y +inc_y
           EndIf  

Next
  
EndProcedure

Procedure _guivmr_kreis( x.w, y.w, w.w, h.w )
  DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend )
  ; ***
  Protected n.d
  ; ***
  If w >= h
    n = h
  Else
    n = w
  EndIf
  ; ***
  n / 2
  ; ***
  LineXY( x + n, y, x + n, y + h, RGBA( 0, 0, 0, 255 ) )
  LineXY( x, y + n, x + w, y + n, RGBA( 0, 0, 0, 255 ) )
  ; ***
  Box( x + n - 1, y + 2, 3, 1, RGBA( 0, 0, 0, 255 ) )
  Box( x + n - 2, y + 3, 5, 1, RGBA( 0, 0, 0, 255 ) )
  Box( x + n - 3, y + 4, 7, 1, RGBA( 0, 0, 0, 255 ) )
  ; ***
  Box( x + n - 1, y + h - 2, 3, 1, RGBA( 0, 0, 0, 255 ) )
  Box( x + n - 2, y + h - 3, 5, 1, RGBA( 0, 0, 0, 255 ) )
  Box( x + n - 3, y + h - 4, 7, 1, RGBA( 0, 0, 0, 255 ) )
  ; ***
  Box( x + 2, y + n - 1, 1, 3, RGBA( 0, 0, 0, 255 ) )
  Box( x + 3, y + n - 2, 1, 5, RGBA( 0, 0, 0, 255 ) )
  Box( x + 4, y + n - 3, 1, 7, RGBA( 0, 0, 0, 255 ) )
  ; ***
  Box( x + w - 2, y + n - 1, 1, 3, RGBA( 0, 0, 0, 255 ) )
  Box( x + w - 3, y + n - 2, 1, 5, RGBA( 0, 0, 0, 255 ) )
  Box( x + w - 4, y + n - 3, 1, 7, RGBA( 0, 0, 0, 255 ) )
  ; ***
  Circle( x + n, y + n, n, RGBA( 60, 200, 70, 255 ) )
EndProcedure

Procedure _guivmr_ellipse( x.w, y.w, w.w, h.w )
  DrawingMode( #PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend )
  ; ***
  Protected n.d, m.d
  ; ***
  n = h / 2
  m = w / 2
  ; ***
  n / 2
  m / 2
  ; ***
  Box( x + ( w / 2 ), y, 1, h, RGBA( 0, 0, 0, 255 ) )
  Box( x, y + ( h / 2 ), w, 1, RGBA( 0, 0, 0, 255 ) )
  ; ***
  Box( x + (w/2) - 1, y + 2, 3, 1, RGBA( 0, 0, 0, 255 ) )
  Box( x + (w/2) - 2, y + 3, 5, 1, RGBA( 0, 0, 0, 255 ) )
  Box( x + (w/2) - 3, y + 4, 7, 1, RGBA( 0, 0, 0, 255 ) )
  ; ***
  Box( x + (w/2) - 1, y + h - 2, 3, 1, RGBA( 0, 0, 0, 255 ) )
  Box( x + (w/2) - 2, y + h - 3, 5, 1, RGBA( 0, 0, 0, 255 ) )
  Box( x + (w/2) - 3, y + h - 4, 7, 1, RGBA( 0, 0, 0, 255 ) )
  ; ***
  Box( x + 2, y + (h/2) - 1, 1, 3, RGBA( 0, 0, 0, 255 ) )
  Box( x + 3, y + (h/2) - 2, 1, 5, RGBA( 0, 0, 0, 255 ) )
  Box( x + 4, y + (h/2) - 3, 1, 7, RGBA( 0, 0, 0, 255 ) )
  ; ***
  Box( x + w - 2, y + (h/2) - 1, 1, 3, RGBA( 0, 0, 0, 255 ) )
  Box( x + w - 3, y + (h/2) - 2, 1, 5, RGBA( 0, 0, 0, 255 ) )
  Box( x + w - 4, y + (h/2) - 3, 1, 7, RGBA( 0, 0, 0, 255 ) )
  ; ***
  Ellipse( x + ( w - m) - m, y + (h - n) - n, w / 2, h / 2, RGBA( 0, 0, 0, 255 ) )
EndProcedure


Procedure draw_visual_measure_render( *instance.gui_visual_measure_render_struct, catch_img.a = 0, target_img.u = 0 )
  Protected w.w, h.w, r.w, c.w, a.a = 0, b.a = 0, outre.i = 0
  Protected pic.u, xx.d, yy.d, ww.d, hh.d, tx.s, axex.w, axey.w, mesu.a
  Protected xi.w, yi.w, _xx.d, _yy.d, _ww.d, _hh.d, lb.s, *obj, ccc.l
  ; ***
  If *instance
    With *instance
      If ListSize(\items()) > 0 And \index >= 0 And \index < ListSize(\items())
        SelectElement( \items(), \index )
        ; ***
        ;If CreateImage( _guivmr_1, (\items()\w * 2) * \pixw, (\items()\h * 2) * \pixh, 32, #PB_Image_Transparent ) And StartDrawing( ImageOutput( _guivmr_1 ) )
        ;  DrawingMode( #PB_2DDrawing_AlphaBlend )
        ;  ; ***
        ;  _guivmr_kreis( 0, 0, OutputWidth(), OutputHeight() )
        ;  ; ***
        ;  StopDrawing()
        ;EndIf
        ;; ***
        If (\items()\w * 2) * \pixw > 0 And (\items()\h * 2) * \pixh > 0
          If CreateImage( _guivmr_2, (\items()\w * 2) * \pixw, (\items()\h * 2) * \pixh, 32, #PB_Image_Transparent ) And StartDrawing( ImageOutput( _guivmr_2 ) )
            DrawingMode( #PB_2DDrawing_AlphaBlend )
            ; ***
            _guivmr_ellipse( 0, 0, OutputWidth(), OutputHeight() )
            ; ***
            StopDrawing()
          EndIf
        EndIf
      EndIf
      ; ***
      If IsGadget( \id ) And GadgetType( \id ) = #PB_GadgetType_Canvas
        If \flag_back = 0
          \flag_back = 1
          ; ***
          If CreateImage( \img_back, 4096, 4096 ) And StartDrawing(ImageOutput( \img_back ) )
            w = OutputWidth()
            h = OutputHeight()
            ; ***
            Box( 0, 0, w, h, \color_back )
            ; ***
            DrawingMode( #PB_2DDrawing_Outlined )
            ; ***
            For r = 0 To ( w / \pixw )
              Select b
                Case 0
                  b = 1
                Case 1
                  b = 0
              EndSelect
              ; ***
              For c = 0 To ( h / \pixh )
                Select a
                  Case 0
                    a = 1
                  Case 1
                    a = 0
                EndSelect
                ; ***
                If a = 1 And b = 1
                  DrawingMode( #PB_2DDrawing_AlphaBlend )
                  ; ***
                  Box( r * \pixw, c * \pixh, \pixw + 1, \pixh + 1, RGBA( 200, 200, 200, 60 ) )
                  ; ***
                  DrawingMode( #PB_2DDrawing_Outlined )
                EndIf
                ; ***
                Box( r * \pixw, c * \pixh, \pixw + 1, \pixh + 1, \color_grid )
              Next
            Next
            ; ***
            DrawingMode( #PB_2DDrawing_AlphaBlend )
            ; ***
            Box( 0, 0, w, h, RGBA( 255, 255, 255, 160 ) )
            ; ***
            StopDrawing()
            ; ***
            GrabImage( \img_back, \img_temp, 0, 0, GadgetWidth(\id), GadgetHeight(\id) )
          EndIf
        EndIf
        ; ***
        If catch_img = 0
          If \zoom = 0
            outre = StartDrawing( CanvasOutput( \id ) )
          Else
            Select \zoom
              Case -9, -8, -7, -6, -5, -4, -3, -2, -1
                If CreateImage( \img_rest, GadgetWidth(\id), GadgetHeight(\id) )
                  outre = StartDrawing(ImageOutput(\img_rest))
                EndIf
              Case 1, 2, 3, 4, 5, 6, 7, 8, 9
                If CreateImage( \img_rest, GadgetWidth(\id) * (\zoom + 6), GadgetHeight(\id) * (\zoom + 6) )
                  outre = StartDrawing(ImageOutput(\img_rest))
                EndIf
            EndSelect
          EndIf
        Else
          If CreateImage( target_img, 2048, 2048 ) ;4096, 4096 )
            outre = StartDrawing(ImageOutput(target_img))
          EndIf
        EndIf
        ; ***
        If outre
          If IsFont(\fid)
            DrawingFont(FontID(\fid))
          EndIf
          ; ***
          Box( 0, 0, OutputWidth(), OutputHeight(), \color_back )
          ; ***
          If catch_img = 1 And \viewmode < 3
            If IsImage(\img_back)
              DrawImage( ImageID( \img_back ), 0, 0 )
            EndIf
          EndIf
          ; ***
          If \viewmode < 3
            If IsImage( \img_temp )
              DrawImage( ImageID( \img_temp ), 0, 0 )
            EndIf
          EndIf
          ; ***
          If ListSize( \items() ) > 0
            ForEach \items()
              If \items()\deleted = 0 And \items()\hidden = 0
                pic = \items()\pic
                xx  = \items()\x
                yy  = \items()\y
                ww  = \items()\w
                hh  = \items()\h
                ; ***
                axex = \items()\axex
                axey = \items()\axey
                mesu = \items()\measure
                ; ***
                lb = \items()\label
                ; ***
                *obj = \items()
                ; ***
                If \items()\proc
                  \items()\proc( pic, xx * \pixw, yy * \pixh, ( ww - xx ) * \pixw, ( hh - yy ) * \pixh, lb, *obj )
                EndIf
                ; ***
                If \edgex1 > xx * \pixw
                  \edgex1 = xx * \pixw
                EndIf
                ; ***
                If \edgey1 > yy * \pixh
                  \edgey1 = yy * \pixh
                EndIf
                ; ***
                If \edgex2 < ( ww - xx ) * \pixw
                  \edgex2 = ( ww - xx ) * \pixw
                EndIf
                ; ***
                If \edgey2 < ( hh - yy ) * \pixh
                  \edgey2 = ( hh - yy ) * \pixh
                EndIf
                ; ***
                If ListIndex( \items() ) = \index
                  _xx = xx
                  _yy = yy
                  _ww = ww
                  _hh = hh
                  If \viewmode = 0
                    ccc = RGB( 160, 20, 25 )
                  Else
                    ccc = \color_text
                  EndIf
                Else
                  ccc = \color_text
                EndIf
                ; ***
                DrawingMode( #PB_2DDrawing_Transparent )
                ; ***
                ;If \items()\type <= 199 And \items()\type <> 97 And \items()\type <> 98 And \items()\type <> 99
                If \items()\type >= 1 And \items()\type <= 22
                  ;Select mesu
                  ;  Case 0 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",")
                  ;    Select \measurevalue - 1
                  ;      Case 0 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",")
                  ;      Case 1 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",") + " mm"
                  ;      Case 2 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",") + " cm"
                  ;      Case 3 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",") + " dm"
                  ;      Case 4 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",") + " m"
                  ;      Case 5 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",") + " in"
                  ;      Case 6 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",") + " pt"
                  ;      Case 7 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",") + " px"
                  ;    EndSelect
                  ;  Case 1 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",") + " mm"
                  ;  Case 2 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",") + " cm"
                  ;  Case 3 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",") + " dm"
                  ;  Case 4 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",") + " m"
                  ;  Case 5 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",") + " in"
                  ;  Case 6 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",") + " pt"
                  ;  Case 7 : tx = ReplaceString(StrD(ww - xx, 2), ".", ",") + " px"
                  ;EndSelect
                  ; ***
                  xi = 0;(((ww - xx) * \pixw) - TextWidth(tx)) / 2
                  ; ***
                  If ( ww - xx ) * \pixw >= 10;TextWidth(tx) + 12
                    ;Box( (xx * \pixw) + xi - 3 + ((ww - xx) * \pixw) - TextWidth(tx) - 12, ( yy * \pixh ) + 1 - 3 + TextHeight(tx), TextWidth(tx) + 6, TextHeight(tx) + 6, \color_back )
                    ; ***
                    ;DrawText( (xx * \pixw) + xi + ((ww - xx) * \pixw) - TextWidth(tx) - 12, ( yy * \pixh ) + 1 + TextHeight(tx), tx, \color_text )
                    ; ***
                    ;If ( yy * \pixh ) - \pixh - 6 - TextHeight(tx) - ( axey * \pixh ) <= (hh * \pixh) - (\pixh + \pixh)
                    ;  Box( (xx * \pixw) + (((( ww - xx ) * \pixw) - TextWidth(tx) ) / 2) - 3, ( yy * \pixh ) - \pixh - 6 - TextHeight(tx) - ( axey * \pixh ), TextWidth(tx) + 6, TextHeight(tx) + 6, \color_back )
                    ;  ; ***
                    ;  DrawText( (xx * \pixw) + (((( ww - xx ) * \pixw) - TextWidth(tx) ) / 2), ( yy * \pixh ) - \pixh - 3 - TextHeight(tx) - ( axey * \pixh ), tx, ccc )
                    ;Else
                    ;  Box( (xx * \pixw) + (((( ww - xx ) * \pixw) - TextWidth(tx) ) / 2) - 3, 6 + ( yy * \pixh ) - \pixh - 6 - ( axey * \pixh ), TextWidth(tx) + 6, TextHeight(tx) + 6, \color_back )
                    ;  ; ***
                    ;  DrawText( (xx * \pixw) + (((( ww - xx ) * \pixw) - TextWidth(tx) ) / 2), 6 + ( yy * \pixh ) - \pixh - 3 - ( axey * \pixh ), tx, ccc )
                    ;EndIf
                    ; ***
                    If ListIndex( \items() ) = \index
                      \measurey[0] = (xx * \pixw) + (((( ww - xx ) * \pixw) - TextWidth(tx) ) / 2) - 3
                      If ( yy * \pixh ) - \pixh - 6 - TextHeight(tx) - ( axey * \pixh ) <= (hh * \pixh) - (\pixh + \pixh)
                        \measurey[1] = ( yy * \pixh ) - \pixh - 6 - TextHeight(tx) - ( axey * \pixh )                      
                      Else
                        \measurey[1] = 6 + ( yy * \pixh ) - \pixh - 6 - ( axey * \pixh )
                      EndIf
                      \measurey[1] = ( yy * \pixh ) - \pixh - 6 - TextHeight(tx) - ( axey * \pixh )
                      \measurey[2] = TextWidth(tx) + 6 + \measurey[0]
                      \measurey[3] = TextHeight(tx) + 6 + \measurey[1]
                      ; ***
                      \measurey[0] - 10
                      \measurey[1] - 10
                      \measurey[2] + 10
                      \measurey[3] + 10
                    EndIf
                    ; ***
                    If \viewmode <= 1 Or \viewmode = 3
                      ;Box( (xx * \pixw), (yy * \pixh) - \pixh - ( axey * \pixh ), ((ww - xx) * \pixw), 1, ccc )
                      ;; ***
                      ;LineXY( (xx * \pixw) - 5, (yy * \pixh) - \pixh - 5 - ( axey * \pixh ), (xx * \pixw) + 5, (yy * \pixh) - \pixh + 5 - ( axey * \pixh ), ccc )
                      ;LineXY( (xx * \pixw) - 5, (yy * \pixh) - \pixh + 5 - ( axey * \pixh ), (xx * \pixw) + 5, (yy * \pixh) - \pixh - 5 - ( axey * \pixh ), ccc )
                      ;; ***
                      ;LineXY( ((xx + (ww - xx)) * \pixw) - 5, (yy * \pixh) - \pixh - 5 - ( axey * \pixh ), ((xx + (ww - xx)) * \pixw) + 5, (yy * \pixh) - \pixh + 5 - ( axey * \pixh ), ccc )
                      ;LineXY( ((xx + (ww - xx)) * \pixw) - 5, (yy * \pixh) - \pixh + 5 - ( axey * \pixh ), ((xx + (ww - xx)) * \pixw) + 5, (yy * \pixh) - \pixh - 5 - ( axey * \pixh ), ccc )
                    EndIf
                  EndIf
                  ; ***
                  ;Select mesu
                  ;  Case 0 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",")
                  ;    Select \measurevalue - 1
                  ;      Case 0 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",")
                  ;      Case 1 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",") + " mm"
                  ;      Case 2 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",") + " cm"
                  ;      Case 3 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",") + " dm"
                  ;      Case 4 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",") + " m"
                  ;      Case 5 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",") + " in"
                  ;      Case 6 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",") + " pt"
                  ;      Case 7 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",") + " px"
                  ;    EndSelect
                  ;  Case 1 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",") + " mm"
                  ;  Case 2 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",") + " cm"
                  ;  Case 3 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",") + " dm"
                  ;  Case 4 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",") + " m"
                  ;  Case 5 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",") + " in"
                  ;  Case 6 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",") + " pt"
                  ;  Case 7 : tx = ReplaceString(StrD(hh - yy, 2), ".", ",") + " px"
                  ;EndSelect
                  ; ***
                  If ( ww - xx ) * \pixw >= 10;TextWidth(tx) + 12
  ;                  Box( (xx * \pixw) + 14 - 3, ((hh - yy) * \pixh) + (yy * \pixh) - \pixh - 3 - 12, TextWidth(tx) + 6, TextHeight(tx) + 6, \color_back )
                    ; ***
  ;                  DrawText( (xx * \pixw) + 14, ((hh - yy) * \pixh) + (yy * \pixh) - \pixh - 12, tx, \color_text )
                    ; ***
                    ;If (xx * \pixw) - \pixw - 6 - TextWidth(tx) - ( axex * \pixw ) <= (ww * \pixw) - (\pixw + \pixw)
                    ;  Box( (xx * \pixw) - \pixw - 6 - TextWidth(tx) - ( axex * \pixw ), (yy * \pixh) + (((( hh - yy ) * \pixh) / 2) - TextHeight(tx)) - 3, TextWidth(tx) + 6, TextHeight(tx) + 6, \color_back )
                    ;  ; ***
                    ;  DrawText( (xx * \pixw) - \pixw - 3 - TextWidth(tx) - ( axex * \pixw ), (yy * \pixh) + (((( hh - yy ) * \pixh) / 2) - TextHeight(tx)), tx, ccc )
                    ;Else
                    ;  Box( (xx * \pixw) - \pixw - 6 + 8 - ( axex * \pixw ), (yy * \pixh) + (((( hh - yy ) * \pixh) / 2) - TextHeight(tx)) - 3, TextWidth(tx) + 6, TextHeight(tx) + 6, \color_back )
                    ;  ; ***
                    ;  DrawText( (xx * \pixw) - \pixw - 3 + 8 - ( axex * \pixw ), (yy * \pixh) + (((( hh - yy ) * \pixh) / 2) - TextHeight(tx)), tx, ccc )
                    ;EndIf
                    ; ***
                    If ListIndex( \items() ) = \index
                      If (xx * \pixw) - \pixw - 6 - TextWidth(tx) - ( axex * \pixw ) <= (ww * \pixw) - (\pixw + \pixw)
                        \measurex[0] = (xx * \pixw) - \pixw - 6 - TextWidth(tx) - ( axex * \pixw )
                      Else
                        \measurex[0] = (xx * \pixw) - \pixw - 6 + 8 - ( axex * \pixw )
                      EndIf
                      ; ***
                      \measurex[1] = (yy * \pixh) + (((( hh - yy ) * \pixh) / 2) - TextHeight(tx)) - 3
                      \measurex[2] = TextWidth(tx) + 6 + \measurex[0]
                      \measurex[3] = TextHeight(tx) + 6 + \measurex[1]
                      ; ***
                      \measurex[0] - 10
                      \measurex[1] - 10
                      \measurex[2] + 10
                      \measurex[3] + 10
                    EndIf
                    ; ***
                    If \viewmode <= 1 Or \viewmode = 3
                      ;Box( (xx * \pixw) - \pixw - ( axex * \pixw ), (yy * \pixh), 1, ((hh - yy) * \pixh), ccc )
                      ;; ***
                      ;LineXY( (xx * \pixw) - \pixw - ( axex * \pixw ) - 5, (yy * \pixh) - 5, (xx * \pixw) - \pixw - ( axex * \pixw ) + 5, (yy * \pixh) + 5, ccc )
                      ;LineXY( (xx * \pixw) - \pixw - ( axex * \pixw ) + 5, (yy * \pixh) - 5, (xx * \pixw) - \pixw - ( axex * \pixw ) - 5, (yy * \pixh) + 5, ccc )
                      ;; ***
                      ;LineXY( (xx * \pixw) - \pixw - ( axex * \pixw ) - 5, (yy * \pixh) - 5 + ((hh - yy) * \pixh), (xx * \pixw) - \pixw - ( axex * \pixw ) + 5, (yy * \pixh) + 5 + ((hh - yy) * \pixh), ccc )
                      ;LineXY( (xx * \pixw) - \pixw - ( axex * \pixw ) + 5, (yy * \pixh) - 5 + ((hh - yy) * \pixh), (xx * \pixw) - \pixw - ( axex * \pixw ) - 5, (yy * \pixh) + 5 + ((hh - yy) * \pixh), ccc )
                    EndIf
                  EndIf
                EndIf
                ; ***
                If \items()\type <= 199
                  If \items()\showlabel = 1 And Trim(\items()\label)
                    ;If ( ww - xx ) * \pixw >= TextWidth(\items()\label) + 12
                    ;  If \items()\label
                    ;    Box( (xx * \pixw) + ( ( ((ww - xx) * \pixw) - TextWidth(\items()\label) ) / 2 ) - 3, (yy * \pixh) + ( ( ((hh - yy) * \pixh) - TextHeight(\items()\label) ) / 2 ) - 3, TextWidth(\items()\label) + 6, TextHeight(\items()\label) + 6, \color_back )
                    ;    ; ***
                    ;    DrawText( (xx * \pixw) + ( ( ((ww - xx) * \pixw) - TextWidth(\items()\label) ) / 2 ), (yy * \pixh) + ( ( ((hh - yy) * \pixh) - TextHeight(\items()\label) ) / 2 ), \items()\label, ccc )
                    ;  EndIf
                    ;EndIf
                    ; ***
                    If \items()\lock = #True And IsImage(1508) And \viewmode <= 2
                      If (ww - xx) * \pixw > TextWidth(\items()\label) + 16
                        DrawAlphaImage( ImageID( 1508 ), 
                                        (xx * \pixw) + ( ( ((ww - xx) * \pixw) - TextWidth(\items()\label) ) / 2 ) + TextWidth(\items()\label),
                                        (yy * \pixh) + ( ( ((hh - yy) * \pixh) - TextHeight(\items()\label) ) / 2 ) )
                      Else
                        DrawAlphaImage( ImageID( 1508 ), 
                                        (xx * \pixw) + ( ( ((ww - xx) * \pixw) - 8 ) / 2 ),
                                        (yy * \pixh) + ( ( ((hh - yy) * \pixh) - TextHeight(\items()\label) ) / 2 ) )
                      EndIf
                    EndIf
                  Else
                    If \items()\lock = #True And IsImage(1508) And \viewmode <= 2
                      DrawAlphaImage( ImageID( 1508 ), 
                                      (xx * \pixw) + ( ( ((ww - xx) * \pixw) - 8 ) / 2 ),
                                      (yy * \pixh) + ( ( ((hh - yy) * \pixh) - 8 ) / 2 ) )
                    EndIf
                  EndIf
                Else
                  If \items()\label
                    Box( (xx * \pixw) + ( ( ((ww - xx) * \pixw) - TextWidth(\items()\label) ) / 2 ) - 3, (yy * \pixh) + ( ( ((hh - yy) * \pixh) - TextHeight(\items()\label) ) / 2 ) - 3, TextWidth(\items()\label) + 6, TextHeight(\items()\label) + 6, \color_back )
                    ; ***
                    DrawText( (xx * \pixw) + ( ( ((ww - xx) * \pixw) - TextWidth(\items()\label) ) / 2 ), (yy * \pixh) + ( ( ((hh - yy) * \pixh) - TextHeight(\items()\label) ) / 2 ), \items()\label, ccc )
                  EndIf
                EndIf
              EndIf
            Next
          EndIf
          ; ***
          If free_scalable_item_mode = 1 And EventType() = #PB_EventType_MouseMove
            DrawingMode( #PB_2DDrawing_Default )
            ; ***
            free_scalable_item_data\x2 = GetGadgetAttribute( \id, #PB_Canvas_MouseX )
            free_scalable_item_data\y2 = GetGadgetAttribute( \id, #PB_Canvas_MouseY )
            ; ***
            LineXY( free_scalable_item_data\x1,
                    free_scalable_item_data\y1,
                    free_scalable_item_data\x2,
                    free_scalable_item_data\y2,
                    RGB( 0, 0, 0 ) )
          EndIf
          ; ***
          If ListSize(\items()) > 0 And \index >= 0 And \index < ListSize(\items()) And \viewmode = 0
            SelectElement( \items(), \index )
            ; ***
            If ListIndex( \items() ) = \index And \items()\deleted = 0 And catch_img = 0
              xx = _xx
              yy = _yy
              ww = _ww
              hh = _hh
              ; TL
              DrawingMode( #PB_2DDrawing_Default )
              Box( (xx * \pixw) - #mexsize, (yy * \pixh) - #mexsize, #mexsize, #mexsize, \color_selm )
              DrawingMode( #PB_2DDrawing_Outlined )
              Box( (xx * \pixw) - #mexsize + 1, (yy * \pixh) - #mexsize + 1, #mexsize - 2, #mexsize - 2, \color_back )
              \rex[0] = (xx * \pixw) - #mexsize
              \rey[0] = (yy * \pixh) - #mexsize
              ; *** TR
              DrawingMode( #PB_2DDrawing_Default )
              Box( (xx * \pixw) + (( ww - xx ) * \pixw), (yy * \pixh) - #mexsize, #mexsize, #mexsize, \color_selm )
              DrawingMode( #PB_2DDrawing_Outlined )
              Box( (xx * \pixw) + (( ww - xx ) * \pixw) + 1, (yy * \pixh) - #mexsize + 1, #mexsize - 2, #mexsize - 2, \color_back )
              \rex[1] = (xx * \pixw) + (( ww - xx ) * \pixw)
              \rey[1] = (yy * \pixh) - #mexsize
              ; *** TM
              DrawingMode( #PB_2DDrawing_Default )
              Box( (xx * \pixw) + (((( ww - xx ) * \pixw) / 2) - 10), (yy * \pixh) - #mexsize, #mexsize, #mexsize, \color_selm )
              DrawingMode( #PB_2DDrawing_Outlined )
              Box( (xx * \pixw) + (((( ww - xx ) * \pixw) / 2) - 10) + 1, (yy * \pixh) - #mexsize + 1, #mexsize - 2, #mexsize - 2, \color_back )
              \rex[2] = (xx * \pixw) + (((( ww - xx ) * \pixw) / 2) - 10)
              \rey[2] = (yy * \pixh) - #mexsize
              ; *** LM 
              DrawingMode( #PB_2DDrawing_Default )
              Box( (xx * \pixw) - #mexsize, (yy * \pixh) + ((( hh - yy ) * \pixh) / 2) - 10, #mexsize, #mexsize, \color_selm )
              DrawingMode( #PB_2DDrawing_Outlined )
              Box( (xx * \pixw) - #mexsize + 1, (yy * \pixh) + ((( hh - yy ) * \pixh) / 2) + 1 - 10, #mexsize - 2, #mexsize - 2, \color_back )
              \rex[3] = (xx * \pixw) - #mexsize
              \rey[3] = (yy * \pixh) + ((( hh - yy ) * \pixh) / 2) - 10
              ; *** RM 
              DrawingMode( #PB_2DDrawing_Default )
              Box( (xx * \pixw) + (( ww - xx ) * \pixw), (yy * \pixh) + ((( hh - yy ) * \pixh) / 2) - 10, #mexsize, #mexsize, \color_selm )
              DrawingMode( #PB_2DDrawing_Outlined )
              Box( (xx * \pixw) + (( ww - xx ) * \pixw) + 1, (yy * \pixh) + ((( hh - yy ) * \pixh) / 2) + 1 - 10, #mexsize - 2, #mexsize - 2, \color_back )
              \rex[4] = (xx * \pixw) + (( ww - xx ) * \pixw)
              \rey[4] = (yy * \pixh) + ((( hh - yy ) * \pixh) / 2) - 10
              ; *** BL
              DrawingMode( #PB_2DDrawing_Default )
              Box( (xx * \pixw) - #mexsize, (yy * \pixh) + (( hh - yy ) * \pixh), #mexsize, #mexsize, \color_selm )
              DrawingMode( #PB_2DDrawing_Outlined )
              Box( (xx * \pixw) - #mexsize + 1, (yy * \pixh) + (( hh - yy ) * \pixh) + 1, #mexsize - 2, #mexsize - 2, \color_back )
              \rex[5] = (xx * \pixw) - #mexsize
              \rey[5] = (yy * \pixh) + (( hh - yy ) * \pixh)
              ; *** BR
              DrawingMode( #PB_2DDrawing_Default )
              Box( (xx * \pixw) + (( ww - xx ) * \pixw), (yy * \pixh) + (( hh - yy ) * \pixh), #mexsize, #mexsize, \color_selm )
              DrawingMode( #PB_2DDrawing_Outlined )
              Box( (xx * \pixw) + (( ww - xx ) * \pixw) + 1, (yy * \pixh) + (( hh - yy ) * \pixh) + 1, #mexsize - 2, #mexsize - 2, \color_back )
              \rex[6] = (xx * \pixw) + (( ww - xx ) * \pixw)
              \rey[6] = (yy * \pixh) + (( hh - yy ) * \pixh)
              ; *** BM
              DrawingMode( #PB_2DDrawing_Default )
              Box( (xx * \pixw) + (((( ww - xx ) * \pixw) / 2) - 10), (yy * \pixh) + (( hh - yy ) * \pixh), #mexsize, #mexsize, \color_selm )
              DrawingMode( #PB_2DDrawing_Outlined )
              Box( (xx * \pixw) + (((( ww - xx ) * \pixw) / 2) - 10) + 1, (yy * \pixh) + (( hh - yy ) * \pixh) + 1, #mexsize - 2, #mexsize - 2, \color_back )
              \rex[7] = (xx * \pixw) + (((( ww - xx ) * \pixw) / 2) - 10)
              \rey[7] = (yy * \pixh) + (( hh - yy ) * \pixh)
              If \resizing > 0
                DrawingMode( #PB_2DDrawing_AlphaBlend )
                ; ***
                Box(\rex[\resizing-1], \rey[\resizing-1], #mexsize, #mexsize, RGBA( Red(\color_back), Green(\color_back), Blue(\color_back), 120 ) )
              EndIf
            EndIf
          EndIf
          ; ***
          If \viewmode < 3
            If \flag_sele = 1
              DrawingMode( #PB_2DDrawing_AlphaBlend )
              ; ***
              Box( \x1 * \pixw, \y1 * \pixh, (\x2 - \x1) * \pixw, (\y2 - \y1) * \pixh, RGBA(Red(\color_selb), Green(\color_selb), Blue(\color_selb), #mexsize ) )
              ; ***
              DrawingMode( #PB_2DDrawing_Outlined )
              ; ***
              Box( \x1 * \pixw, \y1 * \pixh, ((\x2 - \x1) * \pixw) + 1, ((\y2 - \y1) * \pixh) + 1, \color_selb )
              Box( (\x1 * \pixw) - 1, (\y1 * \pixh) - 1, ((\x2 - \x1) * \pixw) + 3, ((\y2 - \y1) * \pixh) + 3, \color_selb )
            ElseIf \flag_sele = 2
              DrawingMode( #PB_2DDrawing_AlphaBlend )
              ; ***
              Box( xx * \pixw, yy * \pixh, (ww - xx) * \pixw, (hh - yy) * \pixh, RGBA(Red(\color_selb), Green(\color_selb), Blue(\color_selb), #mexsize ) )
              ; ***
              DrawingMode( #PB_2DDrawing_Outlined )
              ; ***
              Box( xx * \pixw, yy * \pixh, ((ww - xx) * \pixw) + 1, ((hh - yy) * \pixh) + 1, \color_selb )
              Box( (xx * \pixw) - 1, (yy * \pixh) - 1, ((ww - xx) * \pixw) + 3, ((hh - yy) * \pixh) + 3, \color_selb )
            EndIf
          EndIf
          ; ***
          DrawingMode( #PB_2DDrawing_Outlined )
          ; ***
          Box( 0, 0, OutputWidth(), OutputHeight(), \color_grid )
          ; ***
          StopDrawing()
        EndIf
        ; ***
        If catch_img = 0
          Select \zoom
            Case 1, 2, 3, 4, 5, 6, 7, 8, 9
              ResizeImage( \img_rest, ImageWidth(\img_rest) * (\zoom + 6), ImageHeight(\img_rest) * (\zoom + 6), #PB_Image_Raw )
              ; ***
              If StartDrawing(CanvasOutput(\id))
                If IsImage(\img_rest)
                  DrawImage( ImageID(\img_rest), 0, 0 )
                EndIf
                ; ***
                StopDrawing()
              EndIf
          EndSelect
        EndIf
      EndIf
    EndWith
  EndIf
EndProcedure

Procedure.l add_visual_measure_render_item( *instance.gui_visual_measure_render_struct, type.a, label.s, proc.i, showlabel.a = 0, w.f = 4, h.f = 4 )
  If *instance
    With *instance
      If ListSize(\items())
        LastElement(\items())
      EndIf
      ; ***
      AddElement(\items())
      ; ***
      \items()\showlabel = showlabel
      \items()\label = label
      \items()\type = type
      \items()\proc = proc
      ; ***
      If dl_fx <= dl_mx
        __preset_x1 = dl_fx
        __preset_x2 = dl_mx
      Else
        __preset_x1 = dl_mx
        __preset_x2 = dl_fx
      EndIf
      ; ***
      If dl_fy <= dl_my
        __preset_y1 = dl_fy
        __preset_y2 = dl_my
      Else
        __preset_y1 = dl_my
        __preset_y2 = dl_fy
      EndIf
      ; ***
      \items()\x1 = __preset_x1
      \items()\y1 = __preset_y1
      ; ***
      \items()\x2 = __preset_x2
      \items()\y2 = __preset_y2
      ; ***
      If __preset_x1 And __preset_y1 And __preset_x2 And __preset_y2
        \items()\x = __preset_x1
        \items()\y = __preset_y1
        \items()\w = __preset_x2
        \items()\h = __preset_y2
      Else
        \items()\x = 2
        \items()\y = 2
        \items()\w = w + 2
        \items()\h = h + 2
      EndIf
      ; ***
      \items()\axex = 0
      \items()\axey = 0
      \items()\measure = 0
      \items()\autosize = 1
      ; ***
      __preset_x1 = 0 : __preset_x2 = 0
      __preset_y1 = 0 : __preset_y2 = 0
      ; ***
      draw_visual_measure_render( *instance )
      ; ***
      ProcedureReturn ListIndex(\items())
    EndWith
  EndIf
  ; ***
  ProcedureReturn -1
EndProcedure

Procedure event_visual_measure_render( *instance.gui_visual_measure_render_struct, evt.i )
  Protected p.w, w.w, h.w, x.w, y.w, xx.w, yy.w, ww.w, hh.w
  Protected fx.w, fy.w, _x.w, _y.w, cc.l, *obj
  ; ***
  If *instance
    With *instance
      If IsGadget( \id ) And GadgetType( \id ) = #PB_GadgetType_Canvas And evt = #PB_Event_Gadget And EventGadget() = \id
        Select EventType()
          Case #PB_EventType_LeftDoubleClick
            Select \measurec
              Case 1, 2
                If ListSize(\items()) > 0 And \index >= 0 And \index < ListSize(\items())
                  SelectElement( \items(), \index )
                  ; ***
                  \items()\measure + 1
                  ; ***
                  If \items()\measure >= 8
                    \items()\measure = 0
                  EndIf
                  ; ***
                  draw_visual_measure_render( *instance )
                  ; ***
                  ProcedureReturn
                EndIf
            EndSelect
          Case #PB_EventType_LeftButtonDown
            x = GetGadgetAttribute( \id, #PB_Canvas_MouseX )
            y = GetGadgetAttribute( \id, #PB_Canvas_MouseY )
            ; ***
            If free_scalable_item_mode = 2
              free_scalable_item_mode = 1
              ; ***
              free_scalable_item_data\x1 = x
              free_scalable_item_data\y1 = y
              ; ***
              free_scalable_item_data\x2 = x
              free_scalable_item_data\y2 = y
              ; ***
              ProcedureReturn
            EndIf
            ; ***
            _x = x
            _y = y
            ; ***
            If x > 0 : x / \pixw : EndIf
            If y > 0 : y / \pixh : EndIf
            ; ***
            \clicked = 1
            ; ***
            \fx = x
            \fy = y
            \sx = x
            \sy = y
            \flag_sele = 0
            ; ***
            If ListSize(\items())
              \cx = x
              \cy = y
              ; ***
              \ax = x
              \ay = y
              ; ***
              x * \pixw
              y * \pixh
              ; ***
              \resizing = 0
              ; ***
              If \viewmode = 0
                For p = 0 To 8
                  If _x >= \rex[p] And _x <= \rex[p] + #mexsize And _y >= \rey[p] And _y <= \rey[p] + #mexsize
                    \resizing = p + 1
                    ; ***
                    \flag_sele = 0
                    ; ***
                    ProcedureReturn
                  EndIf
                Next
                ; ***
                If x >= \measurey[0] And x <= \measurey[2] And y >= \measurey[1] And y <= \measurey[3]
                  \measurec = 1
                  ; ***
                  ProcedureReturn
                EndIf
                ; ***
                If x >= \measurex[0] And x <= \measurex[2] And y >= \measurex[1] And y <= \measurex[3]
                  \measurec = 2
                  ; ***
                  ProcedureReturn
                EndIf
              EndIf
              ; ***
              If \viewmode < 3
                cc = ListSize(\items())
                ; ***
                Repeat
                  cc - 1
                  ; ***
                  SelectElement( \items(), cc )
                  ; ***
                  xx = \items()\x * \pixw
                  ww = (\items()\x + \items()\w) * \pixw
                  yy = \items()\y * \pixh
                  hh = (\items()\y + \items()\h) * \pixh
                  ; ***
                  If x >= xx And x <= ww - xx And y >= yy And y <= hh - yy And \items()\deleted = 0 And \items()\hidden = 0 And \items()\lock = 0
                    \index = ListIndex( \items() )
                    \moving = 1
                    \flag_sele = 2
                    ; ***
                    \mx = xx
                    \my = yy
                    \mw = ww - xx
                    \mh = hh - yy
                    ; ***
                    If \mx <> 0 : \mx / \pixw : EndIf
                    If \my <> 0 : \my / \pixh : EndIf
                    If \mw <> 0 : \mw / \pixw : EndIf
                    If \mh <> 0 : \mh / \pixh : EndIf
                    ; ***
                    If \items()\deleted = 0
                      If \cb_item
                        *obj = \items()
                        ; ***
                        \cb_item( *obj, 0 )
                      EndIf
                    EndIf
                    ; ***
                    Break
                  ElseIf x >= xx And x <= ww - xx And y >= yy And y <= hh - yy And \items()\deleted = 0 And \items()\hidden = 0 And \items()\lock = 1
                    If \items()\deleted = 0
                      If \cb_item
                        *obj = \items()
                        ; ***
                        \cb_item( *obj, 0 )
                      EndIf
                    EndIf
                    ; ***
                    Break
                  EndIf
                Until cc = 0
                ; ***
                draw_visual_measure_render( *instance )
              EndIf
            EndIf
            ; ***
            If *obj = 0
              If \cb_area
                \cb_area(0)
              EndIf
            EndIf
          Case #PB_EventType_MouseMove
            x = GetGadgetAttribute( \id, #PB_Canvas_MouseX )
            y = GetGadgetAttribute( \id, #PB_Canvas_MouseY )
            ; ***
            If free_scalable_item_mode = 1
              draw_visual_measure_render( *instance )
              ; ***
              ProcedureReturn
            EndIf
            ; ***
            If x > 0 : x / \pixw : EndIf
            If y > 0 : y / \pixh : EndIf
            ; ***
            \sx = x
            \sy = y
            ; ***
            \px = x
            \py = y
            ; ***
            If \measurec > 0
              Select \measurec
                Case 1 ; Y
                  If ListSize(\items()) > 0 And \index >= 0 And \index < ListSize(\items())
                    SelectElement( \items(), \index )
                    ; ***
                    \items()\axey = - y + \items()\y
                    ; ***
                    draw_visual_measure_render( *instance )
                    ; ***
                    ProcedureReturn
                  EndIf
                Case 2 ; X
                  If ListSize(\items()) > 0 And \index >= 0 And \index < ListSize(\items())
                    SelectElement( \items(), \index )
                    ; ***
                    \items()\axex = - x + \items()\x
                    ; ***
                    draw_visual_measure_render( *instance )
                    ; ***
                    ProcedureReturn
                  EndIf
              EndSelect
            EndIf
            ; ***
            If \sx > \fx
              \x1 = \fx
              \x2 = \sx
            Else
              \x1 = \sx
              \x2 = \fx
            EndIf
            ; ***
            If \sy > \fy
              \y1 = \fy
              \y2 = \sy
            Else
              \y1 = \sy
              \y2 = \fy
            EndIf
            ; ***
            If \resizing > 0
              If ListSize(\items()) > 0 And \index >= 0 And \index < ListSize(\items())
                SelectElement( \items(), \index )
                ; ***
                \flag_sele = 2
                ; ***
                If \items()\deleted = 0 And \items()\hidden = 0 And \items()\lock = 0
                  Select \resizing
                    Case 1 ; TL
                      If \sx < \mw And \sy < \mh
                        \items()\x = \sx
                        \items()\y = \sy
                        \items()\w = \mw
                        \items()\h = \mh
                      EndIf
                    Case 2 ; TR
                      If \sy < \mh And \sx > \items()\x
                        \items()\y = \sy
                        \items()\h = \mh
                        \items()\w = \sx
                      EndIf
                    Case 3 ; TM
                      If \sy < \mh
                        \items()\y = \sy
                        \items()\h = \mh
                      EndIf
                    Case 4 ; LM
                      If \sx < \mw
                        \items()\x = \sx
                        \items()\w = \mw
                      EndIf
                    Case 5 ; RM
                      If \sx > \items()\x
                        \items()\w = \sx
                      EndIf
                    Case 6 ; BL
                      If \sx < \mw And \sy > \items()\y
                        \items()\x = \sx
                        \items()\w = \mw
                        \items()\h = \sy
                      EndIf
                    Case 7 ; BR
                      If \sx > \items()\x And \sy > \items()\y
                        \items()\w = \sx
                        \items()\h = \sy
                      EndIf
                    Case 8 ; BM
                      If \sy > \items()\y
                        \items()\h = \sy
                      EndIf
                  EndSelect
                EndIf
                ; ***
                draw_visual_measure_render( *instance )
                ; ***
                ProcedureReturn
              EndIf
            EndIf
            ; ***
            If \moving = 1
              If ListSize(\items()) > 0 And \index >= 0 And \index < ListSize(\items())
                SelectElement( \items(), \index )
                ; ***
                If \items()\deleted = 0 And \items()\hidden = 0 And \items()\lock = 0
                  \flag_sele = 2
                  ; ***
                  \items()\x = \sx - (\ax - \mx)
                  \items()\y = \sy - (\ay - \my)
                  \items()\w = \items()\x + (\mw - \mx)
                  \items()\h = \items()\y + (\mh - \my)
                EndIf
              EndIf
              ; ***
              draw_visual_measure_render( *instance )
              ; ***
              ProcedureReturn
            EndIf
          Case #PB_EventType_LeftButtonUp
            If free_scalable_item_mode = 1
              free_scalable_item_data\x2 = GetGadgetAttribute( \id, #PB_Canvas_MouseX )
              free_scalable_item_data\y2 = GetGadgetAttribute( \id, #PB_Canvas_MouseY )
              ; ***
              free_scalable_item_data\edlock = 1
              ; ***
              element_dline( free_scalable_item_data\pic,
                             free_scalable_item_data\x,
                             free_scalable_item_data\y,
                             free_scalable_item_data\w,
                             free_scalable_item_data\h,
                             free_scalable_item_data\label,
                             free_scalable_item_data )
            EndIf
            ; ***
            If \x1 <> \x2 And \y1 <> \y2
              \cw = \x2 - \x1
              \ch = \y2 - \y1
            EndIf
            ; ***
            If \clicked = 1
              
            EndIf
            ; ***
            If \moving = 1
              If ListSize(\items()) > 0 And \index >= 0 And \index < ListSize(\items())
                SelectElement( \items(), \index )
                ; ***
                If \items()\deleted = 0 And \items()\hidden = 0
                  xx = \items()\x * \pixw
                  ww = (\items()\x + \items()\w) * \pixw
                  yy = \items()\y * \pixh
                  hh = (\items()\y + \items()\h) * \pixh
                  ; ***
                  \mx = xx
                  \my = yy
                  \mw = ww - xx
                  \mh = hh - yy
                  ; ***
                  If \mx <> 0 : \mx / \pixw : EndIf
                  If \my <> 0 : \my / \pixh : EndIf
                  If \mw <> 0 : \mw / \pixw : EndIf
                  If \mh <> 0 : \mh / \pixh : EndIf
                EndIf
              EndIf
            EndIf
            ; ***
            If \resizing > 0 Or \moving > 0
              \flag_sele = 0
            EndIf
            ; ***
            \measurec = 0
            \clicked = 0
            \moving = 0
            ; ***
            If \resizing > 0
              \resizing = 0
              \flag_sele = 2
              ; ***
              draw_visual_measure_render( *instance )
            EndIf
          Case #PB_EventType_RightButtonUp
            *obj = 0
            ; ***
            x = GetGadgetAttribute( \id, #PB_Canvas_MouseX )
            y = GetGadgetAttribute( \id, #PB_Canvas_MouseY )
            ; ***
            _x = x
            _y = y
            ; ***
            If x > 0 : x / \pixw : EndIf
            If y > 0 : y / \pixh : EndIf
            ; ***
            If ListSize(\items()) > 0 And \index >= 0 And \index < ListSize(\items())
              x * \pixw
              y * \pixh
              ; ***
              SelectElement( \items(), \index )
              ; ***
              xx = \items()\x * \pixw
              ww = (\items()\x + \items()\w) * \pixw
              yy = \items()\y * \pixh
              hh = (\items()\y + \items()\h) * \pixh
              ; ***
              If x >= xx And x <= ww - xx And y >= yy And y <= hh - yy And \items()\deleted = 0 And \items()\hidden = 0
                If \items()\deleted = 0
                  If \cb_item
                    *obj = \items()
                    ; ***
                    \cb_item( *obj, 1 )
                    ; ***
                    ProcedureReturn
                  EndIf
                EndIf
              EndIf
            EndIf
            ; ***
            If *obj = 0
              If \cb_area
                \cb_area(1)
              EndIf
            EndIf
        EndSelect
      EndIf
    EndWith
  EndIf
EndProcedure

Procedure modify_visual_measure_render_item_label( *instance.gui_visual_measure_render_struct, index.l, label.s )
  If *instance
    With *instance
      If ListSize(\items()) > 0 And index >= 0 And index < ListSize(\items())
        SelectElement( \items(), index )
        ; ***
        \items()\label = label
        ; ***
        draw_visual_measure_render( *instance )
      EndIf
    EndWith
  EndIf
EndProcedure

Procedure modify_visual_measure_render_item_notice( *instance.gui_visual_measure_render_struct, index.l, value.s )
  If *instance
    With *instance
      If ListSize(\items()) > 0 And index >= 0 And index < ListSize(\items())
        SelectElement( \items(), index )
        ; ***
        \items()\notice = value
      EndIf
    EndWith
  EndIf
EndProcedure

Procedure set_visual_measure_render_index( *instance.gui_visual_measure_render_struct, index.l )
  If *instance
    With *instance
      If ListSize(\items()) > 0 And index >= 0 And index < ListSize(\items())
        \index = index
      EndIf
    EndWith
  EndIf
EndProcedure

Procedure.l get_visual_measure_render_index( *instance.gui_visual_measure_render_struct )
  If *instance
    With *instance
      ProcedureReturn \index
    EndWith
  EndIf
EndProcedure

Procedure.l set_visual_measure_render_view( *object.gui_visual_measure_object_struct, *instance.gui_visual_measure_render_struct )
  If *object And *instance
    If *instance\rid >= 0 And *instance\rid < ListSize(*object\items()) And ListSize(*object\items()) > 0
      SelectElement( *object\items(), *instance\rid )
      ; ***
      If ListIndex( *object\items() ) >= 0
        *instance\flag_back = 0
        *instance\flag_rest = 0
        *instance\flag_sele = 0
        ; ***
        *instance\resizing = 0
        *instance\clicked = 0
        *instance\moving = 0
        ; ***
        *instance\index = -1
        ; ***
        *object\items()\floor = *instance\floor
        *object\items()\sepunit = *instance\sepunit
        *object\items()\theunit = *instance\theunit
        *object\items()\sepflat = *instance\sepflat
        ; ***
        ClearList( *object\items()\items() )
        ; ***
        ForEach *instance\items()
          AddElement( *object\items()\items() )
          ; ***
          If *instance\items()\deleted = 0
            *object\items()\items()\deleted = 0
            *object\items()\items()\hidden = *instance\items()\hidden
            *object\items()\items()\h = *instance\items()\h
            *object\items()\items()\label = *instance\items()\label
            *object\items()\items()\notice = *instance\items()\notice
            *object\items()\items()\pic = *instance\items()\pic
            *object\items()\items()\proc = *instance\items()\proc
            *object\items()\items()\type = *instance\items()\type
            *object\items()\items()\w = *instance\items()\w
            *object\items()\items()\x = *instance\items()\x
            *object\items()\items()\y = *instance\items()\y
            *object\items()\items()\axex = *instance\items()\axex
            *object\items()\items()\axey = *instance\items()\axey
            *object\items()\items()\measure = *instance\items()\measure
            *object\items()\items()\showlabel = *instance\items()\showlabel
            *object\items()\items()\autosize = *instance\items()\autosize
            *object\items()\items()\lock = *instance\items()\lock
            *object\items()\items()\etop = *instance\items()\etop
            *object\items()\items()\ebottom = *instance\items()\ebottom
            *object\items()\items()\eleft = *instance\items()\eleft
            *object\items()\items()\eright = *instance\items()\eright
            *object\items()\items()\edlock = *instance\items()\edlock
            *object\items()\items()\x1 = *instance\items()\x1
            *object\items()\items()\x2 = *instance\items()\x2
            *object\items()\items()\y1 = *instance\items()\y1
            *object\items()\items()\y2 = *instance\items()\y2
          EndIf
        Next
        ; ***
        draw_visual_measure_render( *instance )
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure.l init_visual_measure_render_view( *object.gui_visual_measure_object_struct, *instance.gui_visual_measure_render_struct, viewnbr.w )
  If *object And *instance
    If viewnbr >= 0 And viewnbr < ListSize(*object\items()) And ListSize(*object\items()) > 0
      SelectElement( *object\items(), viewnbr )
      ; ***
      If ListIndex( *object\items() ) >= 0
        *instance\flag_back = 0
        *instance\flag_rest = 0
        *instance\flag_sele = 0
        ; ***
        *instance\resizing = 0
        *instance\clicked = 0
        *instance\moving = 0
        ; ***
        *instance\index = -1
        ; ***
        If ListIndex( *object\items() ) >= 0
          ClearList( *instance\items() )
          ; ***
          *instance\rid = viewnbr
          ; ***
          *instance\floor = *object\items()\floor
          *instance\sepunit = *object\items()\sepunit
          *instance\theunit = *object\items()\theunit
          *instance\sepflat = *object\items()\sepflat
          ; ***
          ForEach *object\items()\items()
            AddElement( *instance\items() )
            ; ***
            *instance\items()\deleted = 0
            *instance\items()\hidden = *object\items()\items()\hidden
            *instance\items()\h = *object\items()\items()\h
            *instance\items()\label = *object\items()\items()\label
            *instance\items()\notice = *object\items()\items()\notice
            *instance\items()\pic = *object\items()\items()\pic
            *instance\items()\proc = *object\items()\items()\proc
            *instance\items()\type = *object\items()\items()\type
            *instance\items()\w = *object\items()\items()\w
            *instance\items()\x = *object\items()\items()\x
            *instance\items()\y = *object\items()\items()\y
            *instance\items()\axex = *object\items()\items()\axex
            *instance\items()\axey = *object\items()\items()\axey
            *instance\items()\measure = *object\items()\items()\measure
            *instance\items()\showlabel = *object\items()\items()\showlabel
            *instance\items()\autosize = *object\items()\items()\autosize
            *instance\items()\lock = *object\items()\items()\lock
            *instance\items()\etop = *object\items()\items()\etop
            *instance\items()\ebottom = *object\items()\items()\ebottom
            *instance\items()\eleft = *object\items()\items()\eleft
            *instance\items()\eright = *object\items()\items()\eright
            *instance\items()\edlock = *object\items()\items()\edlock
            *instance\items()\x1 = *object\items()\items()\x1
            *instance\items()\x2 = *object\items()\items()\x2
            *instance\items()\y1 = *object\items()\items()\y1
            *instance\items()\y2 = *object\items()\items()\y2
          Next
          ; ***
          draw_visual_measure_render( *instance )
        EndIf
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure.l switch_visual_measure_render_view( *object.gui_visual_measure_object_struct, *instance.gui_visual_measure_render_struct, viewnbr.w )
  If *object And *instance
    If viewnbr >= 0 And viewnbr < ListSize(*object\items()) And ListSize(*object\items()) > 0
      SelectElement( *object\items(), *instance\rid )
      ; ***
      If ListIndex( *object\items() ) >= 0
        *instance\flag_back = 0
        *instance\flag_rest = 0
        *instance\flag_sele = 0
        ; ***
        *instance\resizing = 0
        *instance\clicked = 0
        *instance\moving = 0
        ; ***
        *instance\index = -1
        ; ***
        *object\items()\floor = *instance\floor
        *object\items()\sepunit = *instance\sepunit
        *object\items()\theunit = *instance\theunit
        *object\items()\sepflat = *instance\sepflat
        ; ***
        ClearList( *object\items()\items() )
        ; ***
        ForEach *instance\items()
          AddElement( *object\items()\items() )
          ; ***
          If *instance\items()\deleted = 0
            *object\items()\items()\deleted = 0
            *object\items()\items()\hidden = *instance\items()\hidden
            *object\items()\items()\h = *instance\items()\h
            *object\items()\items()\label = *instance\items()\label
            *object\items()\items()\notice = *instance\items()\notice
            *object\items()\items()\pic = *instance\items()\pic
            *object\items()\items()\proc = *instance\items()\proc
            *object\items()\items()\type = *instance\items()\type
            *object\items()\items()\w = *instance\items()\w
            *object\items()\items()\x = *instance\items()\x
            *object\items()\items()\y = *instance\items()\y
            *object\items()\items()\axex = *instance\items()\axex
            *object\items()\items()\axey = *instance\items()\axey
            *object\items()\items()\measure = *instance\items()\measure
            *object\items()\items()\showlabel = *instance\items()\showlabel
            *object\items()\items()\autosize = *instance\items()\autosize
            *object\items()\items()\lock = *instance\items()\lock
            *object\items()\items()\etop = *instance\items()\etop
            *object\items()\items()\ebottom = *instance\items()\ebottom
            *object\items()\items()\eleft = *instance\items()\eleft
            *object\items()\items()\eright = *instance\items()\eright
            *object\items()\items()\edlock = *instance\items()\edlock
            *object\items()\items()\x1 = *instance\items()\x1
            *object\items()\items()\x2 = *instance\items()\x2
            *object\items()\items()\y1 = *instance\items()\y1
            *object\items()\items()\y2 = *instance\items()\y2
          EndIf
        Next
        ; ***
        SelectElement( *object\items(), viewnbr )
        ; ***
        If ListIndex( *object\items() ) >= 0
          ClearList( *instance\items() )
          ; ***
          *instance\rid = viewnbr
          ; ***
          *instance\floor = *object\items()\floor
          *instance\sepunit = *object\items()\sepunit
          *instance\theunit = *object\items()\theunit
          *instance\sepflat = *object\items()\sepflat
          ; ***
          ForEach *object\items()\items()
            AddElement( *instance\items() )
            ; ***
            *instance\items()\deleted = 0
            *instance\items()\hidden = *object\items()\items()\hidden
            *instance\items()\h = *object\items()\items()\h
            *instance\items()\label = *object\items()\items()\label
            *instance\items()\notice = *object\items()\items()\notice
            *instance\items()\pic = *object\items()\items()\pic
            *instance\items()\proc = *object\items()\items()\proc
            *instance\items()\type = *object\items()\items()\type
            *instance\items()\w = *object\items()\items()\w
            *instance\items()\x = *object\items()\items()\x
            *instance\items()\y = *object\items()\items()\y
            *instance\items()\axex = *object\items()\items()\axex
            *instance\items()\axey = *object\items()\items()\axey
            *instance\items()\measure = *object\items()\items()\measure
            *instance\items()\showlabel = *object\items()\items()\showlabel
            *instance\items()\autosize = *object\items()\items()\autosize
            *instance\items()\lock = *object\items()\items()\lock
            *instance\items()\etop = *object\items()\items()\etop
            *instance\items()\ebottom = *object\items()\items()\ebottom
            *instance\items()\eleft = *object\items()\items()\eleft
            *instance\items()\eright = *object\items()\items()\eright
            *instance\items()\edlock = *object\items()\items()\edlock
            *instance\items()\x1 = *object\items()\items()\x1
            *instance\items()\x2 = *object\items()\items()\x2
            *instance\items()\y1 = *object\items()\items()\y1
            *instance\items()\y2 = *object\items()\items()\y2
          Next
          ; ***
          draw_visual_measure_render( *instance )
        EndIf
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure.a move_visual_measure_render_view( *instance.gui_visual_measure_render_struct, index.l, mode.a )
  If *instance
    With *instance
      If index >= 0 And index < ListSize(\items()) And ListSize(\items()) > 0
        Protected r.gui_visual_measure_item_struct
        Protected d.gui_visual_measure_item_struct
        ; ***
        SelectElement( \items(), index )
        ; ***
        If ListIndex( \items() ) >= 0
          r\hidden = *instance\items()\hidden
          r\h = *instance\items()\h
          r\label = *instance\items()\label
          r\notice = *instance\items()\notice
          r\pic = *instance\items()\pic
          r\proc = *instance\items()\proc
          r\type = *instance\items()\type
          r\w = *instance\items()\w
          r\x = *instance\items()\x
          r\y = *instance\items()\y
          r\axex = *instance\items()\axex
          r\axey = *instance\items()\axey
          r\measure = *instance\items()\measure
          r\showlabel = *instance\items()\showlabel
          r\autosize = *instance\items()\autosize
          r\lock = *instance\items()\lock
          r\etop = *instance\items()\etop
          r\ebottom = *instance\items()\ebottom
          r\eleft = *instance\items()\eleft
          r\eright = *instance\items()\eright
          r\edlock = *instance\items()\edlock
          r\x1 = *instance\items()\x1
          r\x2 = *instance\items()\x2
          r\y1 = *instance\items()\y1
          r\y2 = *instance\items()\y2
          ; ***
          Select mode
            Case 1 ; Rauf
              If index > 0
                SelectElement( \items(), index - 1 )
              Else
                ProcedureReturn
              EndIf
            Case 2 ; Runter
              If index < ListSize(\items()) - 1
                SelectElement( \items(), index + 1 )
              Else
                ProcedureReturn
              EndIf
            Case 3 ; Ans Ende
              FirstElement( \items() )
            Case 4 ; Ans Anfang
              LastElement( \items() )
          EndSelect
          ; ***
          If ListIndex( \items() ) >= 0
            d\hidden = *instance\items()\hidden
            d\h = *instance\items()\h
            d\label = *instance\items()\label
            d\notice = *instance\items()\notice
            d\pic = *instance\items()\pic
            d\proc = *instance\items()\proc
            d\type = *instance\items()\type
            d\w = *instance\items()\w
            d\x = *instance\items()\x
            d\y = *instance\items()\y
            d\axex = *instance\items()\axex
            d\axey = *instance\items()\axey
            d\measure = *instance\items()\measure
            d\showlabel = *instance\items()\showlabel
            d\autosize = *instance\items()\autosize
            d\lock = *instance\items()\lock
            d\etop = *instance\items()\etop
            d\ebottom = *instance\items()\ebottom
            d\eleft = *instance\items()\eleft
            d\eright = *instance\items()\eright
            d\edlock = *instance\items()\edlock
            d\x1 = *instance\items()\x1
            d\x2 = *instance\items()\x2
            d\y1 = *instance\items()\y1
            d\y2 = *instance\items()\y2
            ; ***
            *instance\items()\hidden = d\hidden
            *instance\items()\h = d\h
            *instance\items()\label = d\label
            *instance\items()\notice = d\notice
            *instance\items()\pic = d\pic
            *instance\items()\proc = d\proc
            *instance\items()\type = d\type
            *instance\items()\w = d\w
            *instance\items()\x = d\x
            *instance\items()\y = d\y
            *instance\items()\axex = d\axex
            *instance\items()\axey = d\axey
            *instance\items()\measure = d\measure
            *instance\items()\showlabel = d\showlabel
            *instance\items()\autosize = d\autosize
            *instance\items()\lock = d\lock
            *instance\items()\etop = d\etop
            *instance\items()\ebottom = d\ebottom
            *instance\items()\eleft = d\eleft
            *instance\items()\eright = d\eright
            *instance\items()\edlock = d\edlock
            *instance\items()\x1 = d\x1
            *instance\items()\x2 = d\x2
            *instance\items()\y1 = d\y1
            *instance\items()\y2 = d\y2
            ; ***
            SelectElement( \items(), index )
            ; ***
            If ListIndex( \items() ) >= 0
              *instance\items()\hidden = r\hidden
              *instance\items()\h = r\h
              *instance\items()\label = r\label
              *instance\items()\notice = r\notice
              *instance\items()\pic = r\pic
              *instance\items()\proc = r\proc
              *instance\items()\type = r\type
              *instance\items()\w = r\w
              *instance\items()\x = r\x
              *instance\items()\y = r\y
              *instance\items()\axex = r\axex
              *instance\items()\axey = r\axey
              *instance\items()\measure = r\measure
              *instance\items()\showlabel = r\showlabel
              *instance\items()\autosize = r\autosize
              *instance\items()\lock = r\lock
              *instance\items()\etop = r\etop
              *instance\items()\ebottom = r\ebottom
              *instance\items()\eleft = r\eleft
              *instance\items()\eright = r\eright
              *instance\items()\edlock = r\edlock
              *instance\items()\x1 = r\x1
              *instance\items()\x2 = r\x2
              *instance\items()\y1 = r\y1
              *instance\items()\y2 = r\y2
              ; ***
              ProcedureReturn mode
            EndIf
          EndIf
        EndIf
      EndIf
    EndWith
  EndIf
  ; ***
  ProcedureReturn 0
EndProcedure

Procedure.a copy_visual_measure_render_item( *instance.gui_visual_measure_render_struct, index.l )
  If *instance
    With *instance
      If index >= 0 And index < ListSize(\items()) And ListSize(\items()) > 0
        SelectElement( \items(), index )
        ; ***
        If ListIndex( \items() ) >= 0
          gvmr_copied_entry\hidden = *instance\items()\hidden
          gvmr_copied_entry\h = *instance\items()\h
          gvmr_copied_entry\label = *instance\items()\label
          gvmr_copied_entry\notice = *instance\items()\notice
          gvmr_copied_entry\pic = *instance\items()\pic
          gvmr_copied_entry\proc = *instance\items()\proc
          gvmr_copied_entry\type = *instance\items()\type
          gvmr_copied_entry\w = *instance\items()\w
          gvmr_copied_entry\x = *instance\items()\x
          gvmr_copied_entry\y = *instance\items()\y
          gvmr_copied_entry\axex = *instance\items()\axex
          gvmr_copied_entry\axey = *instance\items()\axey
          gvmr_copied_entry\measure = *instance\items()\measure
          gvmr_copied_entry\showlabel = *instance\items()\showlabel
          gvmr_copied_entry\autosize = *instance\items()\autosize
          gvmr_copied_entry\lock = *instance\items()\lock
          gvmr_copied_entry\etop = *instance\items()\etop
          gvmr_copied_entry\ebottom = *instance\items()\ebottom
          gvmr_copied_entry\eleft = *instance\items()\eleft
          gvmr_copied_entry\eright = *instance\items()\eright
          gvmr_copied_entry\edlock = *instance\items()\edlock
          gvmr_copied_entry\x1 = *instance\items()\x1
          gvmr_copied_entry\x2 = *instance\items()\x2
          gvmr_copied_entry\y1 = *instance\items()\y1
          gvmr_copied_entry\y2 = *instance\items()\y2
        EndIf
      EndIf
    EndWith
  EndIf
  ; ***
  ProcedureReturn 0
EndProcedure

Procedure.a paste_visual_measure_render_item( *instance.gui_visual_measure_render_struct )
  If *instance
    With *instance
      Protected index.l = add_visual_measure_render_item( *instance, 1, "", 0, 0, 4, 4 )
      ; ***
      If index >= 0 And index < ListSize(\items()) And ListSize(\items()) > 0
        SelectElement( \items(), index )
        ; ***
        If ListIndex( \items() ) >= 0
          *instance\items()\hidden = gvmr_copied_entry\hidden
          *instance\items()\h = gvmr_copied_entry\h
          *instance\items()\label = gvmr_copied_entry\label
          *instance\items()\notice = gvmr_copied_entry\notice
          *instance\items()\pic = gvmr_copied_entry\pic
          *instance\items()\proc = gvmr_copied_entry\proc
          *instance\items()\type = gvmr_copied_entry\type
          *instance\items()\w = gvmr_copied_entry\w
          *instance\items()\x = gvmr_copied_entry\x
          *instance\items()\y = gvmr_copied_entry\y
          *instance\items()\axex = gvmr_copied_entry\axex
          *instance\items()\axey = gvmr_copied_entry\axey
          *instance\items()\measure = gvmr_copied_entry\measure
          *instance\items()\showlabel = gvmr_copied_entry\showlabel
          *instance\items()\autosize = gvmr_copied_entry\autosize
          *instance\items()\lock = gvmr_copied_entry\lock
          *instance\items()\etop = gvmr_copied_entry\etop
          *instance\items()\ebottom = gvmr_copied_entry\ebottom
          *instance\items()\eleft = gvmr_copied_entry\eleft
          *instance\items()\eright = gvmr_copied_entry\eright
          *instance\items()\edlock = gvmr_copied_entry\edlock
          *instance\items()\x1 = gvmr_copied_entry\x1
          *instance\items()\x2 = gvmr_copied_entry\x2
          *instance\items()\y1 = gvmr_copied_entry\y1
          *instance\items()\y2 = gvmr_copied_entry\y2
        EndIf
      EndIf
    EndWith
  EndIf
  ; ***
  ProcedureReturn 0
EndProcedure

Procedure.a duplicate_visual_measure_render_item( *instance.gui_visual_measure_render_struct, index.l )
  copy_visual_measure_render_item( *instance, index )
  paste_visual_measure_render_item( *instance )
EndProcedure

Procedure.a duplicate_visual_measure_render_view( *instance.gui_visual_measure_render_struct )

EndProcedure

Procedure.a remove_visual_measure_render_item( *instance.gui_visual_measure_render_struct, index.l = 0 )
  
EndProcedure

Procedure.a remove_visual_measure_render_view( *instance.gui_visual_measure_render_struct )

EndProcedure

Procedure   remove_current_visual_measure_render( *object.gui_visual_measure_object_struct, *instance.gui_visual_measure_render_struct )
  
EndProcedure

Procedure   clear_visual_measure_object( *object.gui_visual_measure_object_struct )
  If *object
    ForEach *object\items()\items()
      *object\items()\items()\deleted = 0
      *object\items()\items()\label = ""
      *object\items()\items()\notice = ""
      *object\items()\items()\type = 0
      *object\items()\items()\proc = 0
      *object\items()\items()\pic = 0
      *object\items()\items()\x = 0
      *object\items()\items()\y = 0
      *object\items()\items()\w = 0
      *object\items()\items()\h = 0
      *object\items()\items()\axex = 0
      *object\items()\items()\axey = 0
      *object\items()\items()\measure = 0
      *object\items()\items()\showlabel = 0
      ; ***
      DeleteElement(*object\items()\items())
    Next
    ; ***
    ForEach *object\items()
      *object\items()\flag_back = 0
      *object\items()\flag_rest = 0
      *object\items()\flag_sele = 0
      ; ***
      *object\items()\resizing = 0
      *object\items()\clicked = 0
      *object\items()\moving = 0
      ; ***
      *object\items()\floor = ""
      *object\items()\theunit = ""
      *object\items()\sepunit = 0
      *object\items()\sepflat = 0
      ; ***
      DeleteElement(*object\items())
    Next
    ; ***
    With *object
      \object = ""
      \address = ""
      \notice = ""
      \path = ""
      \postalcode = ""
      \town = ""
    EndWith
  EndIf
EndProcedure

Procedure.s gvmr_ecrypt( value.s )
  Protected t.s, p.w
  ; ***
  For p = 1 To Len(value)
    Select Mid( value, p, 1 )
      Case Chr(10)
        t + "\n"
      Case Chr(13)
        t + "\r"
      Case Chr(9)
        t + "\t"
      Default
        t + Mid( value, p, 1 )
    EndSelect
  Next
  ; ***
  ProcedureReturn t
EndProcedure

Procedure.s gvmr_decrypt( value.s )
  Protected t.s, p.w
  ; ***
  For p = 1 To Len(value)
    Select Mid( value, p, 2 )
      Case "\n"
        t + Chr(10)
        p + 1
      Case "\r"
        t + Chr(13)
        p + 1
      Case "\t"
        t + Chr(9)
        p + 1
      Default
        t + Mid( value, p, 1 )
    EndSelect
  Next
  ; ***
  ProcedureReturn t
EndProcedure

Global gvmo_object_name.s = ""
Global gvmo_object_path.s = ""

Procedure.a save_to_file( *object.gui_visual_measure_object_struct )
  If *object
    With *object
      If \path = ""
        \path = gvmo_object_path
      EndIf
      ; ***
      If \path = ""
        ProcedureReturn 0
      Else
        If GetExtensionPart( \path ) = "mit"
          If FileSize(\path) <> -1 And FileSize(\path) <> -2
            RenameFile( \path, \path + ".bkp" )
          EndIf
          ; ***
          If CreateFile( 10, \path, #PB_UTF8 )
            WriteStringN( 10, "" )
            WriteStringN( 10, "" )
            WriteStringN( 10, "[base]" )
            WriteStringN( 10, "Software = MeasureIt" )
            WriteStringN( 10, "Version = 1.0.0.0" )
            WriteStringN( 10, "Identity = QELHF-JKLAS-YXCDP-RTUFX-PUJHL" )
            WriteStringN( 10, "" )
            ; ***
            WriteStringN( 10, "[object]" )
            WriteStringN( 10, "customer = " + \object )
            WriteStringN( 10, "address = " + \address )
            WriteStringN( 10, "postalcode = " + \postalcode )
            WriteStringN( 10, "town = " + \town )
            WriteStringN( 10, "" )
            ; ***
            WriteStringN( 10, "[notice]" )
            WriteStringN( 10, \notice )
            WriteStringN( 10, "" )
            ; ***
            ForEach \items()
              If \items()\deleted = 0
                WriteStringN( 10, "[draft]" )
                WriteStringN( 10, "floor = " + \items()\floor )
                WriteStringN( 10, "sepunit = " + Str(\items()\sepunit) )
                WriteStringN( 10, "unit = " + \items()\theunit )
                WriteStringN( 10, "sepmode = " + Str(\items()\sepflat) )
                ; ***
                ForEach \items()\items()
                  If \items()\items()\deleted = 0
                    WriteStringN( 10, "{element}" )
                    WriteStringN( 10, "label = " + Trim(gvmr_ecrypt(\items()\items()\label)) )
                    WriteStringN( 10, "type = " + Str(\items()\items()\type) )
                    WriteStringN( 10, "x = " + Str(\items()\items()\x) )
                    WriteStringN( 10, "y = " + Str(\items()\items()\y) )
                    WriteStringN( 10, "w = " + Str(\items()\items()\w) )
                    WriteStringN( 10, "h = " + Str(\items()\items()\h) )
                    WriteStringN( 10, "ax = " + Str(\items()\items()\axex) )
                    WriteStringN( 10, "ay = " + Str(\items()\items()\axey) )
                    WriteStringN( 10, "me = " + Str(\items()\items()\measure) )
                    WriteStringN( 10, "sl = " + Str(\items()\items()\showlabel) )
                    WriteStringN( 10, "az = " + Str(\items()\items()\autosize) )
                    WriteStringN( 10, "et = " + Str(\items()\items()\etop) )
                    WriteStringN( 10, "eb = " + Str(\items()\items()\ebottom) )
                    WriteStringN( 10, "el = " + Str(\items()\items()\eleft) )
                    WriteStringN( 10, "er = " + Str(\items()\items()\eright) )
                    WriteStringN( 10, "ed = " + Str(\items()\items()\edlock) )
                    WriteStringN( 10, "x1 = " + Str(\items()\items()\x1) )
                    WriteStringN( 10, "x2 = " + Str(\items()\items()\x2) )
                    WriteStringN( 10, "y1 = " + Str(\items()\items()\y1) )
                    WriteStringN( 10, "y2 = " + Str(\items()\items()\y2) )
                  EndIf
                Next
                ; ***
                WriteStringN( 10, "" )
              EndIf
            Next
            ; ***
            CloseFile( 10 )
            ; ***
            If FileSize(\path + ".bkp") <> -1 And FileSize(\path + ".bkp") <> -2
              DeleteFile(\path + ".bkp")
            EndIf
          EndIf
          ; ***
          ProcedureReturn 1
        Else
          ProcedureReturn 0
        EndIf
      EndIf
    EndWith
  EndIf
EndProcedure

Procedure.a load_from_file( *object.gui_visual_measure_object_struct, path.s )
  Protected t.s = "", m.a = 0, ll.s, rr.s
  ; ***
  If *object
    With *object
      If \path And FileSize(\path) <> -1 And FileSize(\path) <> -2
        Select MessageRequester( "Bestätigung", "Änderungen am aktuellen Objekt speichern?", #PB_MessageRequester_YesNoCancel )
          Case #PB_MessageRequester_Yes : save_to_file( *object )
          Case #PB_MessageRequester_Cancel : ProcedureReturn 0
        EndSelect
      EndIf
      ; ***
      If \path = ""
        \path = path
        ; ***
        If GetExtensionPart( \path ) = "mit"
          If ReadFile( 10, \path, #PB_UTF8 )
            gvmo_object_path = \path
            ; ***
            clear_visual_measure_object( *object )
            ; ***
            While Eof(10) = 0
              t = ReadString(10)
              ; ***
              t = Trim(t)
              ; ***
              If t
                Select t
                  Case "[object]"  : m = 1
                  Case "[notice]"  : m = 2
                  Case "[draft]"   : m = 3
                                    If ListSize( \items() )
                                      LastElement( \items() )
                                    EndIf
                                    ; ***
                                    AddElement( \items() )
                  Case "{element}" : m = 4
                  Default
                    Select m
                      Case 1, 2, 3, 4
                        ll = Trim(pick( 0, "=", t ))
                        rr = Trim(pick( 1, "=", t ))
                    EndSelect
                    ; ***
                    Select m
                      Case 1
                        Select ll
                          Case "customer" : \object = rr : gvmo_object_name = rr
                          Case "address" : \address = rr
                          Case "postalcode" : \postalcode = rr
                          Case "town" : \town = rr
                        EndSelect
                      Case 2
                        \notice + t
                      Case 3
                        Select ll
                          Case "floor" : \items()\floor = rr
                          Case "sepunit" : \items()\sepunit = Val(rr)
                          Case "unit" : \items()\theunit = rr
                          Case "sepmode" : \items()\sepflat = Val(rr)
                        EndSelect
                      Case 4
                        If Trim(ll)
                          If ll = "label"
                            If ListSize( \items() )
                              LastElement( \items() )
                            EndIf
                            ; ***
                            If ListSize( \items()\items() )
                              LastElement( \items()\items() )
                            EndIf
                            ; ***
                            AddElement( \items()\items() )
                            ; ***
                            \items()\items()\deleted = 0
                          EndIf
                          ; ***
                          Select ll
                            Case "label" : 
                              \items()\items()\label = Trim(gvmr_decrypt(Trim(rr)))
                            Case "type"  : \items()\items()\type = Val(rr)
                              Select \items()\items()\type
                                Case   1: \items()\items()\proc = @element_quader()
                                Case   2: \items()\items()\proc = @element_ellipse()
                                Case   3: \items()\items()\proc = @element_kreis()
                                Case   4: \items()\items()\proc = @element_quader_90d()
                                Case   5: \items()\items()\proc = @element_sechseck_1()
                                Case   6: \items()\items()\proc = @element_sechseck_2()
                                Case   7: \items()\items()\proc = @element_dreieck_5()
                                Case   8: \items()\items()\proc = @element_dreieck_8()
                                Case   9: \items()\items()\proc = @element_dreieck_6()
                                Case  10: \items()\items()\proc = @element_dreieck_7()
                                Case  11: \items()\items()\proc = @element_dreieck_1()
                                Case  12: \items()\items()\proc = @element_dreieck_2()
                                Case  13: \items()\items()\proc = @element_dreieck_3()
                                Case  14: \items()\items()\proc = @element_dreieck_4()
                                Case  15: \items()\items()\proc = @element_halb_raute_1()
                                Case  16: \items()\items()\proc = @element_halb_raute_3()
                                Case  17: \items()\items()\proc = @element_halb_raute_2()
                                Case  18: \items()\items()\proc = @element_halb_raute_4()
                                Case  19: \items()\items()\proc = @element_teil_raute_1()
                                Case  20: \items()\items()\proc = @element_teil_raute_3()
                                Case  21: \items()\items()\proc = @element_teil_raute_4()
                                Case  22: \items()\items()\proc = @element_teil_raute_2()
                                Case  23: \items()\items()\proc = @element_fenster_1()
                                Case  24: \items()\items()\proc = @element_fenster_2()
                                Case  25: \items()\items()\proc = @element_fenster_3()
                                Case  26: \items()\items()\proc = @element_treppe_1()
                                Case  27: \items()\items()\proc = @element_treppe_2()
                                Case  28: \items()\items()\proc = @element_treppe_3()
                                Case  29: \items()\items()\proc = @element_treppe_4()
                                Case  30: \items()\items()\proc = @element_treppe_5()
                                Case  31: \items()\items()\proc = @element_treppe_6()
                                Case  32: \items()\items()\proc = @element_treppe_7()
                                Case  33: \items()\items()\proc = @element_treppe_8()
                                Case  34: \items()\items()\proc = @element_treppe_9()
                                Case  35: \items()\items()\proc = @element_treppe_10()
                                Case  36: \items()\items()\proc = @element_treppe_11()
                                Case  37: \items()\items()\proc = @element_treppe_12()
                                Case  38: \items()\items()\proc = @element_treppe_13()
                                Case  39: \items()\items()\proc = @element_treppe_14()
                                Case  40: \items()\items()\proc = @element_treppe_15()
                                Case  41: \items()\items()\proc = @element_treppe_16()
                                Case  42: \items()\items()\proc = @element_treppe_17()
                                Case  43: \items()\items()\proc = @element_treppe_18()
                                Case  44: \items()\items()\proc = @element_treppe_19()
                                Case  45: \items()\items()\proc = @element_treppe_20()
                                Case  46: \items()\items()\proc = @element_treppe_21()
                                Case  47: \items()\items()\proc = @element_treppe_22()
                                Case  48: \items()\items()\proc = @element_treppe_23()
                                Case  49: \items()\items()\proc = @element_treppe_24()
                                Case  50: \items()\items()\proc = @element_treppe_25()
                                Case  51: \items()\items()\proc = @element_treppe_26()
                                Case  52: \items()\items()\proc = @element_treppe_27()
                                Case  53: \items()\items()\proc = @element_treppe_28()
                                Case  54: \items()\items()\proc = @element_treppe_29()
                                Case  55: \items()\items()\proc = @element_treppe_30()
                                Case  56: \items()\items()\proc = @element_treppe_31()
                                Case  57: \items()\items()\proc = @element_treppe_32()
                                Case  58: \items()\items()\proc = @element_treppe_33()
                                Case  59: \items()\items()\proc = @element_treppe_34()
                                Case  60: \items()\items()\proc = @element_treppe_35()
                                Case  61: \items()\items()\proc = @element_treppe_36()
                                Case  62: \items()\items()\proc = @element_treppe_37()
                                Case  63: \items()\items()\proc = @element_treppe_38()
                                Case  64: \items()\items()\proc = @element_treppe_39()
                                Case  65: \items()\items()\proc = @element_treppe_40()
                                Case  66: \items()\items()\proc = @element_treppe_41()
                                Case  67: \items()\items()\proc = @element_treppe_42()
                                Case  68: \items()\items()\proc = @element_treppe_43()
                                Case  69: \items()\items()\proc = @element_treppe_44()
                                Case  70: \items()\items()\proc = @element_treppe_45()
                                Case  71: \items()\items()\proc = @element_treppe_46()
                                Case  72: \items()\items()\proc = @element_treppe_47()
                                Case  73: \items()\items()\proc = @element_treppe_48()
                                Case  74: \items()\items()\proc = @element_door_1()
                                Case  75: \items()\items()\proc = @element_door_2()
                                Case  76: \items()\items()\proc = @element_door_3()
                                Case  77: \items()\items()\proc = @element_door_4()
                                Case  78: \items()\items()\proc = @element_door_5()
                                Case  79: \items()\items()\proc = @element_door_6()
                                Case  80: \items()\items()\proc = @element_door_7()
                                Case  81: \items()\items()\proc = @element_door_8()
                                Case  82: \items()\items()\proc = @element_door_9()
                                Case  83: \items()\items()\proc = @element_door_10()
                                Case  84: \items()\items()\proc = @element_door_11()
                                Case  85: \items()\items()\proc = @element_door_12()
                                Case  86: \items()\items()\proc = @element_pfeil_1()
                                Case  87: \items()\items()\proc = @element_pfeil_2()
                                Case  88: \items()\items()\proc = @element_pfeil_3()
                                Case  89: \items()\items()\proc = @element_pfeil_4()
                                Case  90: \items()\items()\proc = @element_aufzug_1()
                                Case  91: \items()\items()\proc = @element_aufzug_2()
                                Case  92: \items()\items()\proc = @element_aufzug_3()
                                Case  93: \items()\items()\proc = @element_aufzug_4()
                                Case  94: \items()\items()\proc = @element_stuetze_1()
                                Case  95: \items()\items()\proc = @element_stuetze_2()
                                Case  96: \items()\items()\proc = @element_kamin()
                                Case  97: \items()\items()\proc = @element_text()
                                Case  98: \items()\items()\proc = @element_number_1()
                                Case  99: \items()\items()\proc = @element_number_2()
                                Case 100: \items()\items()\proc = @element_dachshregen_1()
                                Case 101: \items()\items()\proc = @element_dachshregen_2()
                                Case 102: \items()\items()\proc = @element_dachshregen_3()
                                Case 103: \items()\items()\proc = @element_dachshregen_4()
                                Case 104: \items()\items()\proc = @element_wand_v_1()
                                Case 105: \items()\items()\proc = @element_wand_v_2()
                                Case 106: \items()\items()\proc = @element_wand_v_3()
                                Case 107: \items()\items()\proc = @element_wand_h_1()
                                Case 108: \items()\items()\proc = @element_wand_h_2()
                                Case 109: \items()\items()\proc = @element_wand_h_3()
                                Case 110: \items()\items()\proc = @element_mseinheit_1()
                                Case 111: \items()\items()\proc = @element_mseinheit_2()
                                Case 112: \items()\items()\proc = @element_mseinheit_3()
                                Case 113: \items()\items()\proc = @element_mseinheit_4()
                                Case 114: \items()\items()\proc = @element_mseinheit_5()
                                Case 115: \items()\items()\proc = @element_mseinheit_6()
                                Case 116: \items()\items()\proc = @element_mseinheit_7()
                                Case 117: \items()\items()\proc = @element_mseinheit_8()
                                Case 118: \items()\items()\proc = @element_mseinheit_9()
                                Case 211: \items()\items()\proc = @element_hline()
                                Case 212: \items()\items()\proc = @element_vline()
                                Case 213: \items()\items()\proc = @element_quader()
                                Case 214: \items()\items()\proc = @element_ellipse_3()
                                Case 215: \items()\items()\proc = @element_arrow_up()
                                Case 216: \items()\items()\proc = @element_arrow_down()
                                Case 217: \items()\items()\proc = @element_arrow_left()
                                Case 218: \items()\items()\proc = @element_arrow_right()
                                Case 219: \items()\items()\proc = @element_arrow_up_2()
                                Case 220: \items()\items()\proc = @element_arrow_down_2()
                                Case 221: \items()\items()\proc = @element_arrow_left_2()
                                Case 222: \items()\items()\proc = @element_arrow_right_2()
                                Case 223: \items()\items()\proc = @element_quader_2()
                                Case 224: \items()\items()\proc = @element_ellipse_2()
                                Case 225: \items()\items()\proc = @element_door_13()
                                Case 226: \items()\items()\proc = @element_door_14()
                                Case 227: \items()\items()\proc = @element_door_15()
                                Case 250: \items()\items()\proc = @element_flaster()
                              EndSelect
                            Case "x"     : \items()\items()\x = Val(rr)
                            Case "y"     : \items()\items()\y = Val(rr)
                            Case "w"     : \items()\items()\w = Val(rr)
                            Case "h"     : \items()\items()\h = Val(rr)
                            Case "ax"    : \items()\items()\axex = Val(rr)
                            Case "ay"    : \items()\items()\axey = Val(rr)
                            Case "me"    : \items()\items()\measure = Val(rr)
                            Case "sl"    : \items()\items()\showlabel = Val(rr)
                            Case "az"    : \items()\items()\autosize = Val(rr)
                            Case "et"    : \items()\items()\etop = Val(rr)
                            Case "eb"    : \items()\items()\ebottom = Val(rr)
                            Case "el"    : \items()\items()\eleft = Val(rr)
                            Case "er"    : \items()\items()\eright = Val(rr)
                            Case "ed"    : \items()\items()\edlock = Val(rr)
                            Case "x1"    : \items()\items()\x1 = Val(rr)
                            Case "x2"    : \items()\items()\x2 = Val(rr)
                            Case "y1"    : \items()\items()\y1 = Val(rr)
                            Case "y2"    : \items()\items()\y2 = Val(rr)
                          EndSelect
                        EndIf
                    EndSelect
                EndSelect
              EndIf
            Wend
            ; ***
            CloseFile( 10 )
          EndIf
          ; ***
          ProcedureReturn 1
        Else
          ProcedureReturn 0
        EndIf
      EndIf
    EndWith
  EndIf
EndProcedure





Procedure element_quader( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  With *elm
    If \etop = 0 And \ebottom = 0 And \eleft = 0 And \eright = 0
      Box( x, y, w, h, RGB( 0, 0, 0 ) )
    Else
      DrawingMode( #PB_2DDrawing_Default )
      ; ***
      Box( x, y , \eleft, h, RGB( 0, 0, 0 ) )
      Box( x + w - \eright, y, \eright, h, RGB( 0, 0, 0 ) )
      Box( x, y, w, \etop, RGB( 0, 0, 0 ) )
      Box( x, y + h - \ebottom, w, \ebottom, RGB( 0, 0, 0 ) )
    EndIf
  EndWith
EndProcedure

Procedure element_quader_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  With *elm
    If \etop = 0 And \ebottom = 0 And \eleft = 0 And \eright = 0
      Box( x, y, w, h, RGB( 0, 0, 0 ) )
    Else
      DrawingMode( #PB_2DDrawing_Default )
      ; ***
      Box( x, y , \eleft, h, RGB( 0, 0, 0 ) )
      Box( x + w - \eright, y, \eright, h, RGB( 0, 0, 0 ) )
      Box( x, y, w, \etop, RGB( 0, 0, 0 ) )
      Box( x, y + h - \ebottom, w, \ebottom, RGB( 0, 0, 0 ) )
    EndIf
  EndWith
EndProcedure

Procedure element_kreis( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected n.d
  ; ***
  If w >= h
    n = h
  Else
    n = w
  EndIf
  ; ***
  n / 2
  ; ***
  LineXY( x + n, y, x + n, y + h, RGB( 0, 0, 0 ) )
  LineXY( x, y + n, x + w, y + n, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + n - 1, y + 2, 3, 1, RGB( 0, 0, 0 ) )
  Box( x + n - 2, y + 3, 5, 1, RGB( 0, 0, 0 ) )
  Box( x + n - 3, y + 4, 7, 1, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + n - 1, y + h - 2, 3, 1, RGB( 0, 0, 0 ) )
  Box( x + n - 2, y + h - 3, 5, 1, RGB( 0, 0, 0 ) )
  Box( x + n - 3, y + h - 4, 7, 1, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + 2, y + n - 1, 1, 3, RGB( 0, 0, 0 ) )
  Box( x + 3, y + n - 2, 1, 5, RGB( 0, 0, 0 ) )
  Box( x + 4, y + n - 3, 1, 7, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + w - 2, y + n - 1, 1, 3, RGB( 0, 0, 0 ) )
  Box( x + w - 3, y + n - 2, 1, 5, RGB( 0, 0, 0 ) )
  Box( x + w - 4, y + n - 3, 1, 7, RGB( 0, 0, 0 ) )
  ; ***
  Circle( x + n, y + n, n, RGB( 0, 0, 0 ) )
  ; ***
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  With *elm
    If \etop = 0 And \ebottom = 0 And \eleft = 0 And \eright = 0
      ; ...
    Else
      Circle( x + n, y + n, n, RGB( 0, 0, 0 ) )
      ; ***
      Protected x1.d = \eleft, y1.d = \etop, rr.d = \eright
      ; **
      x1 = x + n
      y1 = y + n
      rr = n
      ; ***
      x1 + \eleft - \eright
      y1 + \etop - \ebottom
      ; **
      If w > h
        rr - \eright
      Else
        rr - \ebottom
      EndIf
      ; ***
      Circle( x1, y1, rr, RGB( 0, 0, 0 ) )
      ; ***
      If \etop > 1
        FillArea( x + 1, y + n - 1, RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
        FillArea( x + 1, y + n + 1, RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
        ; ***
        FillArea( x + n + 1, y + 1, RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
        FillArea( x + n + 2, y + (n * 2) - 2, RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
      EndIf
    EndIf
  EndWith
EndProcedure

Procedure element_ellipse( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected n.d, m.d
  ; ***
  n = h / 2
  m = w / 2
  ; ***
  n / 2
  m / 2
  ; ***
  Box( x + ( w / 2 ), y, 1, h, RGB( 0, 0, 0 ) )
  Box( x, y + ( h / 2 ), w, 1, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + (w/2) - 1, y + 2, 3, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 2, y + 3, 5, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 3, y + 4, 7, 1, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + (w/2) - 1, y + h - 2, 3, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 2, y + h - 3, 5, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 3, y + h - 4, 7, 1, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + 2, y + (h/2) - 1, 1, 3, RGB( 0, 0, 0 ) )
  Box( x + 3, y + (h/2) - 2, 1, 5, RGB( 0, 0, 0 ) )
  Box( x + 4, y + (h/2) - 3, 1, 7, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + w - 2, y + (h/2) - 1, 1, 3, RGB( 0, 0, 0 ) )
  Box( x + w - 3, y + (h/2) - 2, 1, 5, RGB( 0, 0, 0 ) )
  Box( x + w - 4, y + (h/2) - 3, 1, 7, RGB( 0, 0, 0 ) )
  ; ***
  With *elm
    If \etop = 0 And \ebottom = 0 And \eleft = 0 And \eright = 0
      Ellipse( x + ( w - m) - m, y + (h - n) - n, w / 2, h / 2, RGB( 0, 0, 0 ) )
    Else
      Protected x1.d = \eleft, y1.d = \etop, x2.d = \eright, y2.d = \ebottom
      ; ***
      x1 = x + ( w - m) - m
      y1 = y + (h - n) - n
      x2 = w / 2
      y2 = h / 2
      Ellipse( x1, y1, x2, y2, RGB( 0, 0, 0 ) )
      ; ***
      x1 + \eleft - \eright
      y1 + \etop - \ebottom
      x2 - \eright
      y2 - \ebottom
      Ellipse( x1, y1, x2, y2, RGB( 0, 0, 0 ) )
      ; ***
      If \etop > 1
        FillArea( x + 1, y + (h/2) - 1, RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
        FillArea( x + 1, y + (h/2) + 1, RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
        ; ***
        FillArea( x + (w / 2) + 1, y + 1, RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
        FillArea( x + (w / 2) + 2, y + h - 2, RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
      EndIf
    EndIf
  EndWith
EndProcedure

Procedure element_ellipse_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d, m.d
  ; ***
  n = h / 2
  m = w / 2
  ; ***
  n / 2
  m / 2
  ; ***
  Box( x + ( w / 2 ), y, 1, h, RGB( 0, 0, 0 ) )
  Box( x, y + ( h / 2 ), w, 1, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + (w/2) - 1, y + 2, 3, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 2, y + 3, 5, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 3, y + 4, 7, 1, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + (w/2) - 1, y + h - 2, 3, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 2, y + h - 3, 5, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 3, y + h - 4, 7, 1, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + 2, y + (h/2) - 1, 1, 3, RGB( 0, 0, 0 ) )
  Box( x + 3, y + (h/2) - 2, 1, 5, RGB( 0, 0, 0 ) )
  Box( x + 4, y + (h/2) - 3, 1, 7, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + w - 2, y + (h/2) - 1, 1, 3, RGB( 0, 0, 0 ) )
  Box( x + w - 3, y + (h/2) - 2, 1, 5, RGB( 0, 0, 0 ) )
  Box( x + w - 4, y + (h/2) - 3, 1, 7, RGB( 0, 0, 0 ) )
  ; ***
  With *elm
    If \etop = 0 And \ebottom = 0 And \eleft = 0 And \eright = 0
      Ellipse( x + ( w - m) - m, y + (h - n) - n, w / 2, h / 2, RGB( 0, 0, 0 ) )
    Else
      Protected x1.d = \eleft, y1.d = \etop, x2.d = \eright, y2.d = \ebottom
      ; ***
      x1 = x + ( w - m) - m
      y1 = y + (h - n) - n
      x2 = w / 2
      y2 = h / 2
      Ellipse( x1, y1, x2, y2, RGB( 0, 0, 0 ) )
      ; ***
      x1 + \eleft - \eright
      y1 + \etop - \ebottom
      x2 - \eright
      y2 - \ebottom
      Ellipse( x1, y1, x2, y2, RGB( 0, 0, 0 ) )
      ; ***
      If \etop > 1
        FillArea( x + 1, y + (h/2) - 1, RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
        FillArea( x + 1, y + (h/2) + 1, RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
        ; ***
        FillArea( x + (w / 2) + 1, y + 1, RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
        FillArea( x + (w / 2) + 2, y + h - 2, RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
      EndIf
    EndIf
  EndWith
EndProcedure

Procedure element_ellipse_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected n.d, m.d
  ; ***
  n = h / 2
  m = w / 2
  ; ***
  n / 2
  m / 2
  ; ***
  With *elm
    If \etop = 0 And \ebottom = 0 And \eleft = 0 And \eright = 0
      Ellipse( x + ( w - m) - m, y + (h - n) - n, w / 2, h / 2, RGB( 0, 0, 0 ) )
    Else
      Protected x1.d = \eleft, y1.d = \etop, x2.d = \eright, y2.d = \ebottom
      ; ***
      x1 = x + ( w - m) - m
      y1 = y + (h - n) - n
      x2 = w / 2
      y2 = h / 2
      Ellipse( x1, y1, x2, y2, RGB( 0, 0, 0 ) )
      ; ***
      x1 + \eleft - \eright
      y1 + \etop - \ebottom
      x2 - \eright
      y2 - \ebottom
      Ellipse( x1, y1, x2, y2, RGB( 0, 0, 0 ) )
    EndIf
  EndWith
EndProcedure

Procedure element_quader_90d( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected r.d = h / 2, c.d = w / 2
  ; ***
  LineXY( x + c, y, x, y + r, RGB( 0, 0, 0 ) )
  LineXY( x + c, y + h, x, y + r, RGB( 0, 0, 0 ) )
  ; ***
  LineXY( x + c, y, x + w, y + r, RGB( 0, 0, 0 ) )
  LineXY( x + c, y + h, x + w, y + r, RGB( 0, 0, 0 ) )
EndProcedure

Procedure element_dreieck_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d
  ; ***
  With *elm
    Box( x + w - \eright, y, 1 + \eright, h + 1, RGB( 0, 0, 0 ) )
    Box( x, y + h - \ebottom, w, 1 + \ebottom, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + w, y, x, y + h, RGB( 0, 0, 0 ) )
    ; ***
    If \eright > 2 And \ebottom > 2
      LineXY( x + w - \eright, y, x, y + h - \ebottom, RGB( 0, 0, 0 ) )
      ; ***
      FillArea( x + (w / 2) - 1, y + (h / 2) - 1, RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
    EndIf
  EndWith
EndProcedure

Procedure element_dreieck_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d
  ; ***
  With *elm
    Box( x, y, 1 + \eleft, h + 1, RGB( 0, 0, 0 ) )
    Box( x, y + h - \ebottom, w, 1 + \ebottom, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x, y, x + w, y + h, RGB( 0, 0, 0 ) )
    ; ***
    If \eleft > 2 And \ebottom > 2
      LineXY( x + \eleft, y, x + w, y + h - \ebottom, RGB( 0, 0, 0 ) )
      ; ***
      FillArea( x + (w / 2) + 2, y + (h / 2) - 1, RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
    EndIf
  EndWith
EndProcedure

Procedure element_dreieck_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d
  ; ***
  With *elm
    Box( x, y, 1 + \eleft, h + 1, RGB( 0, 0, 0 ) )
    Box( x, y, w, 1 + \etop, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + w, y, x, y + h, RGB( 0, 0, 0 ) )
    ; ***
    If \etop > 2 And \eleft > 2
      LineXY( x + w, y + \etop, x + \eleft, y + h, RGB( 0, 0, 0 ) )
      ; ***
      FillArea( x + (w / 2) + 1, y + (h / 2) + 1, RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
    EndIf
  EndWith
EndProcedure

Procedure element_dreieck_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d
  ; ***
  With *elm
    Box( x + w - \eright, y, 1 + \eright, h + 1, RGB( 0, 0, 0 ) )
    Box( x, y, w, 1 + \etop, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + \eleft, y, x + w, y + h, RGB( 0, 0, 0 ) )
    ; ***
    If \eright > 2
      LineXY( x, y, x + w - \eright, y + h, RGB( 0, 0, 0 ) )
      ; ***
      FillArea( x + (w / 2), y + (h / 2), RGB( 0, 0, 0 ), RGB( 0, 0, 0 ) )
    EndIf
  EndWith
EndProcedure

Procedure element_dreieck_5( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d, p.w
  ; ***
  With *elm
    Box( x, y + h - \ebottom, w, 1 + \ebottom, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + (w / 2), y, x, y + h, RGB( 0, 0, 0 ) )
    LineXY( x + (w / 2), y, x + w, y + h, RGB( 0, 0, 0 ) )
    ; ***
    If \etop > 1
      For p = 0 To \etop
        LineXY( x + (w / 2), y + p, x + p, y + h, RGB( 0, 0, 0 ) )
        LineXY( x + (w / 2), y + p, x + w - p, y + h, RGB( 0, 0, 0 ) )
      Next
    EndIf    
  EndWith
EndProcedure

Procedure element_dreieck_6( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d, p.w
  ; ***
  With *elm
    Box( x, y, w, 1 + \etop, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + (w / 2), y + h, x, y, RGB( 0, 0, 0 ) )
    LineXY( x + (w / 2), y + h, x + w, y, RGB( 0, 0, 0 ) )
    ; ***
    If \etop > 1
      For p = 0 To \etop
        LineXY( x + (w / 2), y + h - p, x + p, y, RGB( 0, 0, 0 ) )
        LineXY( x + (w / 2), y + h - p, x + w - p, y, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_dreieck_7( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d = h / 2, p.w
  ; ***
  With *elm
    Box( x + w - \eright, y, 1 + \eright, h, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x, y + n, x + w, y, RGB( 0, 0, 0 ) )
    LineXY( x, y + n, x + w, y + h - 1, RGB( 0, 0, 0 ) )
    ; ***
    If \etop > 1
      For p = 0 To \etop
        LineXY( x + p, y + n, x + w, y + p, RGB( 0, 0, 0 ) )
        LineXY( x + p, y + n, x + w, y + h - p, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_dreieck_8( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d = h / 2, p.w
  ; ***
  With *elm
    Box( x, y, 1 + \eleft, h, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x, y, x + w, y + n, RGB( 0, 0, 0 ) )
    LineXY( x, y + h - 1, x + w, y + n, RGB( 0, 0, 0 ) )
    ; ***
    If \etop > 1
      For p = 0 To \etop
        LineXY( x, y + p, x + w - p, y + n, RGB( 0, 0, 0 ) )
        LineXY( x, y + h - p, x + w - p, y + n, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_teil_raute_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d = w - ( ( w / 100 ) * 80 ), p.w
  ; ***
  With *elm
    Box( x + n, y, w - n, 1 + \etop, RGB( 0, 0, 0 ) )
    Box( x, y + h - \ebottom, w, 1 + \ebottom, RGB( 0, 0, 0 ) )
    Box( x + w - \eright, y, 1 + \eright, h, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + n, y, x, y + h - 1, RGB( 0, 0, 0 ) )
    ; ***
    If \eleft > 1
      For p = 0 To \eleft
        LineXY( x + n + p, y, x + p, y + h, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_teil_raute_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d = w - ( ( w / 100 ) * 80 ), p.w
  ; ***
  With *elm
    Box( x + n, y + h - \ebottom, w - n, 1 + \ebottom, RGB( 0, 0, 0 ) )
    Box( x, y, w, 1 + \etop, RGB( 0, 0, 0 ) )
    Box( x + w, y, 1 + \eright, h, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x, y, x + n, y + h - 1, RGB( 0, 0, 0 ) )
    ; ***
    If \eleft > 1
      For p = 0 To \eleft
        LineXY( x + p, y, x + n + p, y + h - 1, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_teil_raute_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d = w - ( ( w / 100 ) * 80 ), p.w
  ; ***
  With *elm
    Box( x, y, w - n, 1 + \etop, RGB( 0, 0, 0 ) )
    Box( x, y + h - \ebottom, w, 1 + \ebottom, RGB( 0, 0, 0 ) )
    Box( x, y, 1 + \eleft, h, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + w - n, y, x + w, y + h - 1, RGB( 0, 0, 0 ) )
    ; ***
    If \eleft > 1
      For p = 0 To \eleft
        LineXY( x + w - n - p, y, x + w - p, y + h - 1, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_teil_raute_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d = w - ( ( w / 100 ) * 80 ), p.w
  ; ***
  With *elm
    Box( x, y + h - \ebottom, w - n, 1 + \ebottom, RGB( 0, 0, 0 ) )
    Box( x, y, w, 1 + \etop, RGB( 0, 0, 0 ) )
    Box( x, y, 1 + \eleft, h, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + w - n, y + h - 1, x + w, y, RGB( 0, 0, 0 ) )
    ; ***
    If \eleft > 1
      For p = 0 To \eleft
        LineXY( x + w - n - p, y + h - 1, x + w - p, y, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_voll_raute_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d = w - ( ( w / 100 ) * 20 ), p.w
  ; ***
  With *elm
    Box( x + n, y, w - n - n, 1 + \etop, RGB( 0, 0, 0 ) )
    Box( x, y + h - \ebottom, w, 1 + \ebottom, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + (w - n), y, x, y + h - 1, RGB( 0, 0, 0 ) )
    LineXY( x + n, y, x + w, y + h - 1, RGB( 0, 0, 0 ) )
    ; ***
    If \eleft > 1
      For p = 0 To \eleft
        LineXY( x + (w - n) + p, y, x + p, y + h, RGB( 0, 0, 0 ) )
        LineXY( x + n - p, y, x + w - p, y + h - 1, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_voll_raute_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d = w - ( ( w / 100 ) * 20 ), p.w
  ; ***
  With *elm
    Box( x, y, w, 1 + \etop, RGB( 0, 0, 0 ) )
    Box( x + n, y + h - \ebottom, w - n - n, 1 + \ebottom, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x, y, x + (w - n), y + h - 1, RGB( 0, 0, 0 ) )
    LineXY( x + w, y, x + n, y + h - 1, RGB( 0, 0, 0 ) )
    ; ***
    If \eleft > 1
      For p = 0 To \eleft
        LineXY( x + p, y, x + (w - n) + p, y + h - 1, RGB( 0, 0, 0 ) )
        LineXY( x + w - p, y, x + n - p, y + h - 1, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_viertel_raute_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d = h - ( ( h / 100 ) * 80 ), p.w
  ; ***
  With *elm
    Box( x + w - \eright, y, 1 + \eright, h, RGB( 0, 0, 0 ) )
    ; ***
    Box( x + n, y, w - n, 1 + \etop, RGB( 0, 0, 0 ) )
    Box( x + n, y + h - \ebottom, w - n, 1 + \ebottom, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + n, y, x, y + (h / 2), RGB( 0, 0, 0 ) )
    LineXY( x, y + (h / 2), x + n, y + h, RGB( 0, 0, 0 ) )
    ; ***
    If \eleft > 1
      For p = 0 To \eleft
        LineXY( x + n + p, y, x + p, y + (h / 2), RGB( 0, 0, 0 ) )
        LineXY( x + p, y + (h / 2), x + n + p, y + h, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_viertel_raute_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d = h - ( ( h / 100 ) * 80 ), p.w
  ; ***
  With *elm
    Box( x, y, 1 + \eleft, h, RGB( 0, 0, 0 ) )
    ; ***
    Box( x, y, w - n, 1 + \etop, RGB( 0, 0, 0 ) )
    Box( x, y + h - \ebottom, w - n, 1 + \ebottom, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + w - n, y, x + w, y + (h / 2), RGB( 0, 0, 0 ) )
    LineXY( x + w, y + (h / 2), x + w - n, y + h, RGB( 0, 0, 0 ) )
    ; ***
    If \eleft > 1
      For p = 0 To \eleft
        LineXY( x + w - n - p, y, x + w - p, y + (h / 2), RGB( 0, 0, 0 ) )
        LineXY( x + w - p, y + (h / 2), x + w - n - p, y + h, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_halb_raute_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.w = h / 2, p.w
  ; ***
  With *elm
    Box( x, y + h - \ebottom, w, 1 + \ebottom, RGB( 0, 0, 0 ) )
    Box( x, y + n, 1 + \eleft, n, RGB( 0, 0, 0 ) )
    Box( x + w - \eright, y + n, 1 + \eright, n, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + ( w / 2 ), y, x, y + n, RGB( 0, 0, 0 ) )
    LineXY( x + ( w / 2 ), y, x + w - 1, y + n, RGB( 0, 0, 0 ) )
    ; ***
    If \etop > 1
      For p = 0 To \etop
        LineXY( x + ( w / 2 ), y + p, x, y + n + p, RGB( 0, 0, 0 ) )
        LineXY( x + ( w / 2 ), y + p, x + w, y + n + p, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_halb_raute_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.w = h / 2, p.w
  ; ***
  With *elm
    Box( x, y, w, 1 + \etop, RGB( 0, 0, 0 ) )
    Box( x, y, 1 + \eleft, n, RGB( 0, 0, 0 ) )
    Box( x + w - \eright, y, 1 + \eright, n, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + ( w / 2 ), y + h - 1, x, y + n, RGB( 0, 0, 0 ) )
    LineXY( x + ( w / 2 ), y + h - 1, x + w - 1, y + n, RGB( 0, 0, 0 ) )
    ; ***
    If \etop > 1
      For p = 0 To \etop
        LineXY( x + ( w / 2 ), y + h - p, x, y + n - p, RGB( 0, 0, 0 ) )
        LineXY( x + ( w / 2 ), y + h - p, x + w - 1, y + n - p, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_halb_raute_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.w = w / 2, p.w
  ; ***
  With *elm
    Box( x, y, 1 + \eleft, h, RGB( 0, 0, 0 ) )
    Box( x, y, n, 1 + \etop, RGB( 0, 0, 0 ) )
    Box( x, y + h - \ebottom, n, 1 + \ebottom, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + n, y, x + w, y + ( h / 2), RGB( 0, 0, 0 ) )
    LineXY( x + n, y + h - 1, x + w, y + (h / 2), RGB( 0, 0, 0 ) )
    ; ***
    If \etop > 1
      For p = 0 To \etop
        LineXY( x + n - p, y, x + w - p, y + ( h / 2), RGB( 0, 0, 0 ) )
        LineXY( x + n - p, y + h - 1, x + w - p, y + (h / 2), RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_halb_raute_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.w = w / 2, p.w
  ; ***
  With *elm
    Box( x + w - \eright, y, 1 + \eright, h, RGB( 0, 0, 0 ) )
    Box( x + w - n, y, n, 1 + \etop, RGB( 0, 0, 0 ) )
    Box( x + w - n, y + h - \ebottom, n, 1 + \ebottom, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x, y + ( h / 2), x + n, y, RGB( 0, 0, 0 ) )
    LineXY( x, y + ( h / 2), x + n, y + h - 1, RGB( 0, 0, 0 ) )
    ; ***
    If \etop > 1
      For p = 0 To \etop
        LineXY( x + p, y + ( h / 2), x + n + p, y, RGB( 0, 0, 0 ) )
        LineXY( x + p, y + ( h / 2), x + n + p, y + h - 1, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_sechseck_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d = w - ( ( w / 100 ) * 20 ), p.w
  ; ***
  With *elm
    Box( x + n, y, w - n - n, 1 + \etop, RGB( 0, 0, 0 ) )
    Box( x + n, y + h - \etop, w - n - n, 1 + \etop, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + w - n, y, x, y + (h / 2), RGB( 0, 0, 0 ) )
    LineXY( x, y + (h / 2), x + w - n, y + h, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x + n, y, x + w, y + (h / 2), RGB( 0, 0, 0 ) )
    LineXY( x + w, y + (h / 2), x + n, y + h, RGB( 0, 0, 0 ) )
    ; ***
    If \etop > 1
      For p = 0 To \etop
        LineXY( x + w - n + p, y, x + p, y + (h / 2), RGB( 0, 0, 0 ) )
        LineXY( x + p, y + (h / 2), x + w - n + p, y + h, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x + n - p, y, x + w - p, y + (h / 2), RGB( 0, 0, 0 ) )
        LineXY( x + w - p, y + (h / 2), x + n - p, y + h, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_sechseck_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *elm.gui_visual_measure_item_struct = *obj
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d = h - ( ( h / 100 ) * 20 ), p.w
  ; ***
  With *elm
    Box( x, y + n, 1 + \eleft, h - n - n, RGB( 0, 0, 0 ) )
    Box( x + w - \eright, y + n, 1 + \eright, h - n - n, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x, y + h - n, x + (w / 2), y, RGB( 0, 0, 0 ) )
    LineXY( x + (w / 2), y, x + w, y + h - n, RGB( 0, 0, 0 ) )
    ; ***
    LineXY( x, y + n, x + (w / 2), y + h, RGB( 0, 0, 0 ) )
    LineXY( x + (w / 2), y + h, x + w, y + n, RGB( 0, 0, 0 ) )
    ; ***
    If \etop > 1
      For p = 0 To \etop
        LineXY( x, y + h - n + p, x + (w / 2), y + p, RGB( 0, 0, 0 ) )
        LineXY( x + (w / 2), y + p, x + w, y + h - n + p, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x, y + n - p, x + (w / 2), y + h - p, RGB( 0, 0, 0 ) )
        LineXY( x + (w / 2), y + h - p, x + w, y + n - p, RGB( 0, 0, 0 ) )
      Next
    EndIf
  EndWith
EndProcedure

Procedure element_fenster_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Box( x, y, w, h, RGB( 255, 255, 255 ) )
  ; ***
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Box( x, y, w, h, RGB( 0, 0, 0 ) )
  ; ***
  Box( x, y + (h / 2), w, 1, RGB( 0, 0, 0 ) )
EndProcedure

Procedure element_fenster_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Box( x, y, w, h, RGB( 255, 255, 255 ) )
  ; ***
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Box( x, y, w, h, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + (w / 2), y, 1, h, RGB( 0, 0, 0 ) )
EndProcedure

Procedure element_pfeil_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected p.w = (w / 2)
  Protected c.l = RGB( 0, 0, 0 )
  ; ***
  Box( x + p - 1, y + 1, 3, 1, c )
  Box( x + p - 2, y + 2, 5, 1, c )
  Box( x + p - 3, y + 3, 7, 1, c )
  Box( x + p - 4, y + 4, 9, 1, c )
  Box( x + p - 5, y + 5, 11, 1, c )
  ; ***
  Box( x + p, y, 1, h, c )
EndProcedure

Procedure element_pfeil_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected p.w = (w / 2)
  Protected c.l = RGB( 0, 0, 0 )
  ; ***
  Box( x + p - 1, y + h - 1 - 1, 3, 1, c )
  Box( x + p - 2, y + h - 2 - 1, 5, 1, c )
  Box( x + p - 3, y + h - 3 - 1, 7, 1, c )
  Box( x + p - 4, y + h - 4 - 1, 9, 1, c )
  Box( x + p - 5, y + h - 5 - 1, 11, 1, c )
  ; ***
  Box( x + p, y, 1, h, c )
EndProcedure

Procedure element_pfeil_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected p.w = (h / 2)
  Protected c.l = RGB( 0, 0, 0 )
  ; ***
  Box( x + 1, y + p - 1, 1, 3, c )
  Box( x + 2, y + p - 2, 1, 5, c )
  Box( x + 3, y + p - 3, 1, 7, c )
  Box( x + 4, y + p - 4, 1, 9, c )
  Box( x + 5, y + p - 5, 1, 11, c )
  ; ***
  Box( x, y + p, w, 1, c )
EndProcedure

Procedure element_pfeil_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected p.w = (h / 2)
  Protected c.l = RGB( 0, 0, 0 )
  ; ***
  Box( x + w - 1 - 1, y + p - 1, 1, 3, c )
  Box( x + w - 2 - 1, y + p - 2, 1, 5, c )
  Box( x + w - 3 - 1, y + p - 3, 1, 7, c )
  Box( x + w - 4 - 1, y + p - 4, 1, 9, c )
  Box( x + w - 5 - 1, y + p - 5, 1, 11, c )
  ; ***
  Box( x, y + p, w, 1, c )
EndProcedure

Procedure element_text( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected swi.a = 0, c.l = RGB( 0, 0, 0 ), p.w, ww.w = x, hh.w = y
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Box( x, y, w, h, RGB( 255, 255, 255 ) )
  ; ***
  DrawingMode( #PB_2DDrawing_Transparent )
  ; ***
  For p = 1 To Len(text)
    Select Mid(text, p, 1)
      Case Chr(10), Chr(13)
        Select swi
          Case 0
            swi = 1
            ; ***
            ww = x
            ; ***
            hh + TextHeight(text)
          Case 1
            swi = 0
            ; ***
            ; Hier nicht!
        EndSelect
      Case Chr(9)
        If ww + TextWidth("   ") < x + w
          DrawText( ww, hh, "   ", c )
          ; ***
          ww + TextWidth("   ")
        Else
          ww = x
          ; ***
          hh + TextHeight(text)
          ; ***
          DrawText( ww, hh, "   ", c )
          ; ***
          ww + TextWidth("   ")
        EndIf
      Default
        If ww + TextWidth(Mid(text, p, 1)) < x + w
          DrawText( ww, hh, Mid(text, p, 1), c )
          ; ***
          ww + TextWidth(Mid(text, p, 1))
        Else
          ww = x
          ; ***
          hh + TextHeight(text)
          ; ***
          DrawText( ww, hh, Mid(text, p, 1), c )
          ; ***
          ww + TextWidth(Mid(text, p, 1))
        EndIf
    EndSelect
  Next
EndProcedure

Procedure element_number_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d, m.d
  ; ***
  n = h / 2
  m = w / 2
  ; ***
  n / 2
  m / 2
  ; ***
  Box( x + ( w / 2 ), y, 1, h, RGB( 0, 0, 0 ) )
  Box( x, y + ( h / 2 ), w, 1, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + (w/2) - 1, y + 2, 3, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 2, y + 3, 5, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 3, y + 4, 7, 1, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + (w/2) - 1, y + h - 2, 3, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 2, y + h - 3, 5, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 3, y + h - 4, 7, 1, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + 2, y + (h/2) - 1, 1, 3, RGB( 0, 0, 0 ) )
  Box( x + 3, y + (h/2) - 2, 1, 5, RGB( 0, 0, 0 ) )
  Box( x + 4, y + (h/2) - 3, 1, 7, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + w - 2, y + (h/2) - 1, 1, 3, RGB( 0, 0, 0 ) )
  Box( x + w - 3, y + (h/2) - 2, 1, 5, RGB( 0, 0, 0 ) )
  Box( x + w - 4, y + (h/2) - 3, 1, 7, RGB( 0, 0, 0 ) )
  ; ***
  Ellipse( x + ( w - m) - m, y + (h - n) - n, w / 2, h / 2, RGB( 0, 0, 0 ) )
  ; ***
  DrawingMode( #PB_2DDrawing_Transparent )
  ; ***
  n = ( w - TextWidth(text) ) / 2
  m = ( h - TextHeight(text) ) / 2
  ; ***
  n + x
  m + y
  ; ***
  DrawText( n, m, text, RGB( 255, 255, 255 ), RGB( 0, 0, 0 ) )
EndProcedure

Procedure element_number_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.d, m.d, t.s
  ; ***
  n = h / 2
  m = w / 2
  ; ***
  n / 2
  m / 2
  ; ***
  Box( x + ( w / 2 ), y, 1, h, RGB( 0, 0, 0 ) )
  Box( x, y + ( h / 2 ), w, 1, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + (w/2) - 1, y + 2, 3, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 2, y + 3, 5, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 3, y + 4, 7, 1, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + (w/2) - 1, y + h - 2, 3, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 2, y + h - 3, 5, 1, RGB( 0, 0, 0 ) )
  Box( x + (w/2) - 3, y + h - 4, 7, 1, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + 2, y + (h/2) - 1, 1, 3, RGB( 0, 0, 0 ) )
  Box( x + 3, y + (h/2) - 2, 1, 5, RGB( 0, 0, 0 ) )
  Box( x + 4, y + (h/2) - 3, 1, 7, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + w - 2, y + (h/2) - 1, 1, 3, RGB( 0, 0, 0 ) )
  Box( x + w - 3, y + (h/2) - 2, 1, 5, RGB( 0, 0, 0 ) )
  Box( x + w - 4, y + (h/2) - 3, 1, 7, RGB( 0, 0, 0 ) )
  ; ***
  Ellipse( x + ( w - m) - m, y + (h - n) - n, w / 2, h / 2, RGB( 0, 0, 0 ) )
  ; ***
  DrawingMode( #PB_2DDrawing_Transparent )
  ; ***
  Select Val(text)
    Case 1 : t = "a"
    Case 2 : t = "b"
    Case 3 : t = "c"
    Case 4 : t = "d"
    Case 5 : t = "e"
    Case 6 : t = "f"
    Case 7 : t = "g"
    Case 8 : t = "h"
    Case 9 : t = "i"
    Case 10 : t = "j"
    Case 11 : t = "k"
    Case 12 : t = "l"
    Case 13 : t = "m"
    Case 14 : t = "n"
    Case 15 : t = "o"
    Case 16 : t = "p"
    Case 17 : t = "q"
    Case 18 : t = "r"
    Case 19 : t = "s"
    Case 20 : t = "t"
    Case 21 : t = "u"
    Case 22 : t = "v"
    Case 23 : t = "w"
    Case 24 : t = "x"
    Case 25 : t = "y"
    Case 26 : t = "z"
  EndSelect
  ; ***
  n = ( w - TextWidth(t) ) / 2
  m = ( h - TextHeight(t) ) / 2
  ; ***
  n + x
  m + y
  ; ***
  DrawText( n, m, t, RGB( 255, 255, 255 ), RGB( 0, 0, 0 ) )
EndProcedure

Procedure element_treppe_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  ; ***
  Line( x, y, ww, 1, c )
  Line( x, y + h, w, 1, c )
  ; ***
  Line( x, y, 1, h, c )
  Line( x, y, 1, hh, c )
  ; ***
  Line( x + ww, y, 1, hh, c )
  ; ***
  Line( x + ww, y + hh, ww, 1, c )
  ; ***
  Line( x + w, y + hh, 1, hh + 1, c )
  ; ***
  Box( x + w2, y + 2, 1, h - h2, c )
  Box( x + w2, y + h - h2 + 2, w - w2 - 2, 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w - 6, y + h - h2 + 2, 3, c )
  ; ***
  Box( x + w2 - 1, y + 3, 3, 1, c )
  Box( x + w2 - 2, y + 4, 5, 1, c )
  Box( x + w2 - 3, y + 5, 7, 1, c )
  Box( x + w2 - 4, y + 6, 9, 1, c )
  Box( x + w2 - 5, y + 7, 11, 1, c )
EndProcedure

Procedure element_treppe_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  ; ***
  Line( x, y, w, 1, c )
  Line( x + ww, y + hh, ww, 1, c )
  Line( x, y + h, ww, 1, c )
  ; ***
  Line( x, y, 1, h, c )
  Line( x + w, y, 1, hh, c )
  Line( x + ww, y + hh, 1, hh + 1, c )
  ; ***
  Box( x + w2, y + h2, w - w2 - 2, 1, c )
  Box( x + w2, y + h2, 1, h - h2 - 2, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w2, y + h - 6, 3, c )
  ; ***
  Box( x + w - 4, y + h2 - 1, 1, 3, c )
  Box( x + w - 5, y + h2 - 2, 1, 5, c )
  Box( x + w - 6, y + h2 - 3, 1, 7, c )
  Box( x + w - 7, y + h2 - 4, 1, 9, c )
  Box( x + w - 8, y + h2 - 5, 1, 11, c )
EndProcedure

Procedure element_treppe_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  ; ***
  Line( x, y, w, 1, c )
  Line( x, y + hh, ww, 1, c )
  Line( x + ww, y + h, ww, 1, c )
  ; ***
  Line( x, y, 1, hh, c )
  Line( x + ww, y + hh, 1, hh + 1, c )
  Line( x + w, y, 1, h, c )
  ; ***
  Box( x + 2, y + h2, w - 2 - w2, 1, c )
  Box( x + w - w2, y + h2, 1, h - h2 - 2, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + 5, y + h2, 3, c )
  ; ***
  Box( x + ww + w2 - 1, y + h - 4, 3, 1, c )
  Box( x + ww + w2 - 2, y + h - 5, 5, 1, c )
  Box( x + ww + w2 - 3, y + h - 6, 7, 1, c )
  Box( x + ww + w2 - 4, y + h - 7, 9, 1, c )
  Box( x + ww + w2 - 5, y + h - 8, 11, 1, c )
EndProcedure

Procedure element_treppe_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  ; ***
  Line( x + ww, y, ww, 1, c )
  Line( x, y + hh, ww, 1, c )
  Line( x, y + h, w, 1, c )
  ; ***
  Line( x + ww, y, 1, hh + 1, c )
  Line( x, y + hh, 1, hh + 1, c )
  Line( x + w, y, 1, h + 1, c )
  ; ***
  Box( x + 2, y + h - h2, w - w2 - 2, 1, c )
  Box( x + w - w2, y + 2, 1, h - h2 - 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w - w2, y + 5, 3, c )
  ; ***
  Box( x + 3, y + h - h2 - 1, 1, 3, c )
  Box( x + 4, y + h - h2 - 2, 1, 5, c )
  Box( x + 5, y + h - h2 - 3, 1, 7, c )
  Box( x + 6, y + h - h2 - 4, 1, 9, c )
  Box( x + 7, y + h - h2 - 5, 1, 11, c )
EndProcedure

Procedure element_treppe_5( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  ; ***
  Line( x, y, ww, 1, c )
  Line( x, y + h, w, 1, c )
  ; ***
  Line( x, y, 1, h, c )
  Line( x, y, 1, hh, c )
  ; ***
  Line( x + ww, y, 1, hh, c )
  ; ***
  Line( x + ww, y + hh, ww, 1, c )
  ; ***
  Line( x + w, y + hh, 1, hh + 1, c )
  ; ***
  Box( x + w2, y + 2, 1, h - h2, c )
  Box( x + w2, y + h - h2 + 2, w - w2 - 2, 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w - 6, y + h - h2 + 2, 3, c )
  ; ***
  Box( x + w2 - 1, y + 3, 3, 1, c )
  Box( x + w2 - 2, y + 4, 5, 1, c )
  Box( x + w2 - 3, y + 5, 7, 1, c )
  Box( x + w2 - 4, y + 6, 9, 1, c )
  Box( x + w2 - 5, y + 7, 11, 1, c )
  ; ***
  LineXY( x, y + h, x + ww, y + hh, c )
EndProcedure

Procedure element_treppe_6( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  ; ***
  Line( x, y, w, 1, c )
  Line( x + ww, y + hh, ww, 1, c )
  Line( x, y + h, ww, 1, c )
  ; ***
  Line( x, y, 1, h, c )
  Line( x + w, y, 1, hh, c )
  Line( x + ww, y + hh, 1, hh + 1, c )
  ; ***
  Box( x + w2, y + h2, w - w2 - 2, 1, c )
  Box( x + w2, y + h2, 1, h - h2 - 2, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w2, y + h - 6, 3, c )
  ; ***
  Box( x + w - 4, y + h2 - 1, 1, 3, c )
  Box( x + w - 5, y + h2 - 2, 1, 5, c )
  Box( x + w - 6, y + h2 - 3, 1, 7, c )
  Box( x + w - 7, y + h2 - 4, 1, 9, c )
  Box( x + w - 8, y + h2 - 5, 1, 11, c )
  ; ***
  LineXY( x, y, x + ww, y + hh, c )
EndProcedure

Procedure element_treppe_7( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  ; ***
  Line( x, y, w, 1, c )
  Line( x, y + hh, ww, 1, c )
  Line( x + ww, y + h, ww, 1, c )
  ; ***
  Line( x, y, 1, hh, c )
  Line( x + ww, y + hh, 1, hh + 1, c )
  Line( x + w, y, 1, h, c )
  ; ***
  Box( x + 2, y + h2, w - 2 - w2, 1, c )
  Box( x + w - w2, y + h2, 1, h - h2 - 2, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + 5, y + h2, 3, c )
  ; ***
  Box( x + ww + w2 - 1, y + h - 4, 3, 1, c )
  Box( x + ww + w2 - 2, y + h - 5, 5, 1, c )
  Box( x + ww + w2 - 3, y + h - 6, 7, 1, c )
  Box( x + ww + w2 - 4, y + h - 7, 9, 1, c )
  Box( x + ww + w2 - 5, y + h - 8, 11, 1, c )
  ; ***
  LineXY( x + ww, y + hh, x + w, y, c )
EndProcedure

Procedure element_treppe_8( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  ; ***
  Line( x + ww, y, ww, 1, c )
  Line( x, y + hh, ww, 1, c )
  Line( x, y + h, w, 1, c )
  ; ***
  Line( x + ww, y, 1, hh + 1, c )
  Line( x, y + hh, 1, hh + 1, c )
  Line( x + w, y, 1, h + 1, c )
  ; ***
  Box( x + 2, y + h - h2, w - w2 - 2, 1, c )
  Box( x + w - w2, y + 2, 1, h - h2 - 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w - w2, y + 5, 3, c )
  ; ***
  Box( x + 3, y + h - h2 - 1, 1, 3, c )
  Box( x + 4, y + h - h2 - 2, 1, 5, c )
  Box( x + 5, y + h - h2 - 3, 1, 7, c )
  Box( x + 6, y + h - h2 - 4, 1, 9, c )
  Box( x + 7, y + h - h2 - 5, 1, 11, c )
  ; ***
  LineXY( x + ww, y + hh, x + w, y + h, c )
EndProcedure

Procedure element_treppe_9( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w - 6, y + h - 6, 3, c )
  ; ***
  LineXY( x + ww, y + h - h2, x + w - 3, y + h - 3, c )
  LineXY( x + ww, y + h2, x + w - 6, y + 2, c )
  LineXY( x + ww, y + h2, x + ww, y + h - h2, c )
  ; ***
  If IsImage( 1500 )
    xx = x + w - ImageWidth(1500) - 2
    yy = y + 2
    ; ***
    DrawAlphaImage( ImageID( 1500 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_10( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + 5, y + h - 6, 3, c )
  ; ***
  LineXY( x + 2, y + h - 3, x + ww, y + h - h2, c )
  LineXY( x + 2, y + 2, x + ww, y + h2, c )
  LineXY( x + ww, y + h2, x + ww, y + h - h2, c )
  ; ***
  If IsImage( 1501 )
    xx = x + 2
    yy = y + 2
    ; ***
    DrawAlphaImage( ImageID( 1501 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_11( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w - 6, y + 5, 3, c )
  ; ***
  LineXY( x + ww, y + h - h2, x + w - 5, y + h - 5, c )
  LineXY( x + ww, y + h2, x + w - 6, y + 2, c )
  LineXY( x + ww, y + h2, x + ww, y + h - h2, c )
  ; ***
  If IsImage( 1502 )
    xx = x + w - ImageWidth(1502) - 2
    yy = y + h - ImageHeight(1502) - 2
    ; ***
    DrawAlphaImage( ImageID( 1502 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_12( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + 5, y + 5, 3, c )
  ; ***
  LineXY( x + 2, y + h - 3, x + ww, y + h - h2, c )
  LineXY( x + 2, y + 2, x + ww, y + h2, c )
  LineXY( x + ww, y + h2, x + ww, y + h - h2, c )
  ; ***
  If IsImage( 1503 )
    xx = x + 2
    yy = y + h - ImageHeight(1503) - 2
    ; ***
    DrawAlphaImage( ImageID( 1503 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_13( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + 5, y + h - 6, 3, c )
  ; ***
  LineXY( x + w2, y + hh, x + w - w2, y + hh, c )
  LineXY( x + 3, y + h - 3, x + w2, y + hh, c )
  LineXY( x + w - 6, y + h - 3, x + w - w2, y + hh, c )
  ; ***
  If IsImage( 1504 )
    xx = x + w - ImageWidth(1504) - 2
    yy = y + h - ImageHeight(1504) - 2
    ; ***
    DrawAlphaImage( ImageID( 1504 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_14( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + 5, y + 5, 3, c )
  ; ***
  LineXY( x + w2, y + hh, x + w - w2, y + hh, c )
  LineXY( x + 3, y + 2, x + w2, y + hh, c )
  LineXY( x + w - 6, y + 2, x + w - w2, y + hh, c )
  ; ***
  If IsImage( 1505 )
    xx = x + w - ImageWidth(1505) - 2
    yy = y + 2
    ; ***
    DrawAlphaImage( ImageID( 1505 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_15( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w - 6, y + h - 6, 3, c )
  ; ***
  LineXY( x + w2, y + hh, x + w - w2, y + hh, c )
  LineXY( x + 3, y + h - 3, x + w2, y + hh, c )
  LineXY( x + w - 6, y + h - 3, x + w - w2, y + hh, c )
  ; ***
  If IsImage( 1504 )
    xx = x + 2
    yy = y + h - ImageHeight(1504) - 2
    ; ***
    DrawAlphaImage( ImageID( 1504 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_16( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w - 6, y + 5, 3, c )
  ; ***
  LineXY( x + w2, y + hh, x + w - w2, y + hh, c )
  LineXY( x + 3, y + 2, x + w2, y + hh, c )
  LineXY( x + w - 6, y + 2, x + w - w2, y + hh, c )
  ; ***
  If IsImage( 1505 )
    xx = x + 2
    yy = y + 2
    ; ***
    DrawAlphaImage( ImageID( 1505 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_17( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w - 6, y + h - 6, 3, c )
  ; ***
  LineXY( x + ww, y + 3, x + ww, y + h - h2, c )
  LineXY( x + ww, y + h - h2, x + w - 4, y + h - 4, c )
  ; ***
  If IsImage( 1504 )
    xx = x + ww - ( ImageWidth(1504) / 2)
    yy = y + 2
    ; ***
    DrawAlphaImage( ImageID( 1504 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_18( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + 5, y + h - 6, 3, c )
  ; ***
  LineXY( x + ww, y + 3, x + ww, y + h - h2, c )
  LineXY( x + ww, y + h - h2, x + 5, y + h - 4, c )
  ; ***
  If IsImage( 1504 )
    xx = x + ww - ( ImageWidth(1504) / 2)
    yy = y + 2
    ; ***
    DrawAlphaImage( ImageID( 1504 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_19( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w - 6, y + 5, 3, c )
  ; ***
  LineXY( x + ww, y + h2, x + ww, y + h - 3, c )
  LineXY( x + ww, y + h2, x + w - 4, y + 2, c )
  ; ***
  If IsImage( 1505 )
    xx = x + ww - ( ImageWidth(1505) / 2)
    yy = y + h - ImageHeight(1505) - 1
    ; ***
    DrawAlphaImage( ImageID( 1505 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_20( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + 5, y + 5, 3, c )
  ; ***
  LineXY( x + ww, y + h2, x + ww, y + h - 3, c )
  LineXY( x + ww, y + h2, x + 2, y + 2, c )
  ; ***
  If IsImage( 1505 )
    xx = x + ww - ( ImageWidth(1505) / 2)
    yy = y + h - ImageHeight(1505) - 1
    ; ***
    DrawAlphaImage( ImageID( 1505 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_21( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + 5, y + h - 6, 3, c )
  ; ***
  LineXY( x + w2, y + hh, x + w - 3, y + hh, c )
  LineXY( x + w2, y + hh, x + 2, y + h - 4, c )
  ; ***
  If IsImage( 1507 )
    xx = x + w - ImageWidth(1507) - 1
    yy = y + hh - ( ImageHeight(1507) / 2)
    ; ***
    DrawAlphaImage( ImageID( 1507 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_22( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + 5, y + 5, 3, c )
  ; ***
  LineXY( x + w2, y + hh, x + w - 3, y + hh, c )
  LineXY( x + w2, y + hh, x + 2, y + 2, c )
  ; ***
  If IsImage( 1507 )
    xx = x + w - ImageWidth(1507) - 1
    yy = y + hh - ( ImageHeight(1507) / 2)
    ; ***
    DrawAlphaImage( ImageID( 1507 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_23( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w - 6, y + h - 6, 3, c )
  ; ***
  LineXY( x + 3, y + hh, x + w - w2, y + hh, c )
  LineXY( x + w - w2, y + hh, x + w - 4, y + h - 4, c )
  ; ***
  If IsImage( 1506 )
    xx = x + 2
    yy = y + hh - ( ImageHeight(1506) / 2)
    ; ***
    DrawAlphaImage( ImageID( 1506 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_24( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w - 6, y + 5, 3, c )
  ; ***
  LineXY( x + 3, y + hh, x + w - w2, y + hh, c )
  LineXY( x + w - w2, y + hh, x + w - 4, y + 2, c )
  ; ***
  If IsImage( 1506 )
    xx = x + 2
    yy = y + hh - ( ImageHeight(1506) / 2)
    ; ***
    DrawAlphaImage( ImageID( 1506 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_25( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + ww, y + h - 6, 3, c )
  ; ***
  LineXY( x + ww, y + 3, x + ww, y + h - 3, c )
  ; ***
  If IsImage( 1504 )
    xx = x + ww - ( ImageWidth(1504) / 2)
    yy = y + 2
    ; ***
    DrawAlphaImage( ImageID( 1504 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_26( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + ww, y + 5, 3, c )
  ; ***
  LineXY( x + ww, y + 3, x + ww, y + h - 3, c )
  ; ***
  If IsImage( 1505 )
    xx = x + ww - ( ImageWidth(1505) / 2)
    yy = y + h - ImageHeight(1505) - 1
    ; ***
    DrawAlphaImage( ImageID( 1505 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_27( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + 5, y + hh, 3, c )
  ; ***
  LineXY( x + 3, y + hh, x + w - 3, y + hh, c )
  ; ***
  If IsImage( 1507 )
    xx = x + w - ImageWidth(1507) - 1
    yy = y + hh - ( ImageHeight(1507) / 2)
    ; ***
    DrawAlphaImage( ImageID( 1507 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_28( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w
  ; ***
  Box( x, y, w, h, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w - 6, y + hh, 3, c )
  ; ***
  LineXY( x + 3, y + hh, x + w - 3, y + hh, c )
  ; ***
  If IsImage( 1506 )
    xx = x + 2
    yy = y + hh - ( ImageHeight(1506) / 2)
    ; ***
    DrawAlphaImage( ImageID( 1506 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_29( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  ; ***
  Line( x, y, w, 1, c )
  ; ***
  Line( x, y, 1, h, c )
  Line( x + w, y, 1, h, c )
  ; ***
  Line( x + ww - mm, y + hh, 1, hh, c )
  Line( x + ww + mm, y + hh, 1, hh, c )
  ; ***
  Line( x + ww - mm, y + hh, #mexsize, 1, c )
  ; ***
  Line( x, y + h, ww - mm, 1, c )
  Line( x + ww + mm, y + h, ww - mm, 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + ((ww - mm) / 2), y + hh - h2, 1, hh + h2, c )
  ; ***
  Line( x + ((ww - mm) / 2), y + hh - h2, w - ww + mm, 1, c )
  ; ***
  Circle( x + ((ww - mm) / 2), y + h - 6, 3, c )
  ; ***
  If IsImage( 1505 )
    xx = x + w - ( ((ww - mm) / 2) ) - ( ImageWidth(1505) / 2)
    yy = y + h - ImageHeight(1505) - 1
    ; ***
    Line( xx + ( ImageWidth(1505) / 2), y + hh - h2, 1, hh + h2, c )
    ; ***
    DrawAlphaImage( ImageID( 1505 ), xx, yy + 1 )
  EndIf
EndProcedure

Procedure element_treppe_30( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  ; ***
  Line( x, y, w, 1, c )
  ; ***
  Line( x, y, 1, h, c )
  Line( x + w, y, 1, h, c )
  ; ***
  Line( x + ww - mm, y + hh, 1, hh, c )
  Line( x + ww + mm, y + hh, 1, hh, c )
  ; ***
  Line( x + ww - mm, y + hh, #mexsize, 1, c )
  ; ***
  Line( x, y + h, ww - mm, 1, c )
  Line( x + ww + mm, y + h, ww - mm, 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + w - ((ww - mm) / 2), y + hh - h2, 1, hh + h2, c )
  ; ***
  Line( x + ((ww - mm) / 2), y + hh - h2, w - ww + mm, 1, c )
  ; ***
  Circle( x + w - ((ww - mm) / 2), y + h - 6, 3, c )
  ; ***
  If IsImage( 1505 )
    xx = x +( ((ww - mm) / 2) ) - ( ImageWidth(1505) / 2)
    yy = y + h - ImageHeight(1505) - 1
    ; ***
    Line( xx + ( ImageWidth(1505) / 2), y + hh - h2, 1, hh + h2, c )
    ; ***
    DrawAlphaImage( ImageID( 1505 ), xx, yy + 1 )
  EndIf
EndProcedure

Procedure element_treppe_31( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  ; ***
  Line( x, y + h, w, 1, c )
  ; ***
  Line( x, y, 1, h, c )
  Line( x + w, y, 1, h, c )
  ; ***
  Line( x + ww - mm, y, 1, hh, c )
  Line( x + ww + mm, y, 1, hh, c )
  ; ***
  Line( x + ww - mm, y + hh, #mexsize, 1, c )
  ; ***
  Line( x, y, ww - mm, 1, c )
  Line( x + ww + mm, y, ww - mm, 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + ((ww - mm) / 2), y + 3, 1, hh + h2, c )
  ; ***
  Line( x + ((ww - mm) / 2), y + h - h2 + 2, w - ww + mm, 1, c )
  ; ***
  Circle( x + ((ww - mm) / 2), y + 6, 3, c )
  ; ***
  If IsImage( 1504 )
    xx = x + w - ( ((ww - mm) / 2) ) - ( ImageWidth(1504) / 2)
    yy = y + 3
    ; ***
    Line( xx + ( ImageWidth(1504) / 2), y + 3, 1, hh + h2, c )
    ; ***
    DrawAlphaImage( ImageID( 1504 ), xx, yy - 1 )
  EndIf
EndProcedure

Procedure element_treppe_32( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  ; ***
  Line( x, y + h, w, 1, c )
  ; ***
  Line( x, y, 1, h, c )
  Line( x + w, y, 1, h, c )
  ; ***
  Line( x + ww - mm, y, 1, hh, c )
  Line( x + ww + mm, y, 1, hh, c )
  ; ***
  Line( x + ww - mm, y + hh, #mexsize, 1, c )
  ; ***
  Line( x, y, ww - mm, 1, c )
  Line( x + ww + mm, y, ww - mm, 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + w - ((ww - mm) / 2), y + 3, 1, hh + h2, c )
  ; ***
  Line( x + ((ww - mm) / 2), y + h - h2 + 2, w - ww + mm, 1, c )
  ; ***
  Circle( x + w - ((ww - mm) / 2), y + 6, 3, c )
  ; ***
  If IsImage( 1504 )
    xx = x +( ((ww - mm) / 2) ) - ( ImageWidth(1505) / 2)
    yy = y + 3
    ; ***
    Line( xx + ( ImageWidth(1504) / 2), y + 3, 1, hh + h2, c )
    ; ***
    DrawAlphaImage( ImageID( 1504 ), xx, yy - 1 )
  EndIf
EndProcedure

Procedure element_treppe_33( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  ; ***
  Line( x, y, 1, h, c )
  ; ***
  Line( x, y, w, 1, c )
  Line( x, y + h, w, 1, c )
  ; ***
  Line( x + ww, y + hh - mm, ww, 1, c )
  Line( x + ww, y + hh + mm, ww, 1, c )
  ; ***
  Line( x + ww, y + hh - mm, 1, #mexsize, c )
  ; ***
  Line( x + w, y, 1, hh - mm + 1, c )
  Line( x + w, y + hh + mm, 1, hh - mm + 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + w2, y + h - ((hh - mm) / 2), ww + w2 - 3, 1, c )
  Line( x + w2, y + ((hh - mm) / 2), ww + w2 - 3, 1, c )
  ; ***
  Line( x + w2, y + ((hh - mm) / 2), 1, h - hh + mm, c )
  ; ***
  Circle( x + w - 6, y + ((hh - mm) / 2), 3, c )
  ; ***
  If IsImage( 1507 )
    xx = x + w - ImageWidth(1507) - 1
    yy = y + h - ( ((hh - mm) / 2) ) - ( ImageHeight(1507) / 2)
    ; ***
    DrawAlphaImage( ImageID( 1507 ), xx, yy - 1 )
  EndIf
EndProcedure

Procedure element_treppe_34( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  ; ***
  Line( x, y, 1, h, c )
  ; ***
  Line( x, y, w, 1, c )
  Line( x, y + h, w, 1, c )
  ; ***
  Line( x + ww, y + hh - mm, ww, 1, c )
  Line( x + ww, y + hh + mm, ww, 1, c )
  ; ***
  Line( x + ww, y + hh - mm, 1, #mexsize, c )
  ; ***
  Line( x + w, y, 1, hh - mm + 1, c )
  Line( x + w, y + hh + mm, 1, hh - mm + 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + w2, y + h - ((hh - mm) / 2), ww + w2 - 3, 1, c )
  Line( x + w2, y + ((hh - mm) / 2), ww + w2 - 3, 1, c )
  ; ***
  Line( x + w2, y + ((hh - mm) / 2), 1, h - hh + mm, c )
  ; ***
  Circle( x + w - 6, y + h - ((hh - mm) / 2), 3, c )
  ; ***
  If IsImage( 1507 )
    xx = x + w - ImageWidth(1507) - 1
    yy = y + ((hh - mm) / 2) - ( ImageHeight(1507) / 2)
    ; ***
    DrawAlphaImage( ImageID( 1507 ), xx, yy - 1 )
  EndIf
EndProcedure

Procedure element_treppe_35( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  ; ***
  Line( x + w, y, 1, h, c )
  ; ***
  Line( x, y, w, 1, c )
  Line( x, y + h, w, 1, c )
  ; ***
  Line( x, y + hh - mm, ww + 1, 1, c )
  Line( x, y + hh + mm, ww + 1, 1, c )
  ; ***
  Line( x + ww, y + hh - mm, 1, #mexsize, c )
  ; ***
  Line( x, y, 1, hh - mm + 1, c )
  Line( x, y + hh + mm, 1, hh - mm + 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + 3, y + h - ((hh - mm) / 2), ww + w2 - 3, 1, c )
  Line( x + 5, y + ((hh - mm) / 2), ww + w2 - 5, 1, c )
  ; ***
  Line( x + ww + w2, y + ((hh - mm) / 2), 1, h - hh + mm + 1, c )
  ; ***
  Circle( x + 6, y + ((hh - mm) / 2), 3, c )
  ; ***
  If IsImage( 1506 )
    xx = x + 2
    yy = y + h - ( ((hh - mm) / 2) ) - ( ImageHeight(1506) / 2)
    ; ***
    DrawAlphaImage( ImageID( 1506 ), xx, yy - 1 )
  EndIf
EndProcedure

Procedure element_treppe_36( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  ; ***
  Line( x + w, y, 1, h, c )
  ; ***
  Line( x, y, w, 1, c )
  Line( x, y + h, w, 1, c )
  ; ***
  Line( x, y + hh - mm, ww + 1, 1, c )
  Line( x, y + hh + mm, ww + 1, 1, c )
  ; ***
  Line( x + ww, y + hh - mm, 1, #mexsize, c )
  ; ***
  Line( x, y, 1, hh - mm + 1, c )
  Line( x, y + hh + mm, 1, hh - mm + 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + 3, y + h - ((hh - mm) / 2), ww + w2 - 3, 1, c )
  Line( x + 5, y + ((hh - mm) / 2), ww + w2 - 5, 1, c )
  ; ***
  Line( x + ww + w2, y + ((hh - mm) / 2), 1, h - hh + mm + 1, c )
  ; ***
  Circle( x + 6, y + h - ((hh - mm) / 2), 3, c )
  ; ***
  If IsImage( 1506 )
    xx = x + 2
    yy = y + ( ((hh - mm) / 2) ) - ( ImageHeight(1506) / 2)
    ; ***
    DrawAlphaImage( ImageID( 1506 ), xx, yy - 1 )
  EndIf
EndProcedure

Procedure element_treppe_37( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  Protected sz.w
  ; ***
  paintCircle( x, y, w / 2, c, 1, #True )
  ; ***
  sz = (w / 2)
  ; ***
  Line( x, y + sz, 1, h - sz, c )
  Line( x + w, y + sz, 1, h - sz + 1, c )
  ; ***
  Line( x + ww - mm, y + hh, 1, hh + 1, c )
  Line( x + ww + mm, y + hh, 1, hh, c )
  ; ***
  Line( x + ww - mm, y + hh, #mexsize, 1, c )
  ; ***
  Line( x, y + h, ww - mm, 1, c )
  Line( x + ww + mm, y + h, ww - mm, 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + ((ww - mm) / 2), y + hh - h2, 1, hh + h2, c )
  ; ***
  Line( x + ((ww - mm) / 2), y + hh - h2, w - ww + mm, 1, c )
  ; ***
  Circle( x + ((ww - mm) / 2), y + h - 6, 3, c )
  ; ***
  If IsImage( 1505 )
    xx = x + w - ( ((ww - mm) / 2) ) - ( ImageWidth(1505) / 2)
    yy = y + h - ImageHeight(1505) - 1
    ; ***
    Line( xx + ( ImageWidth(1505) / 2), y + hh - h2, 1, hh + h2, c )
    ; ***
    DrawAlphaImage( ImageID( 1505 ), xx, yy + 1 )
  EndIf
EndProcedure

Procedure element_treppe_38( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  Protected sz.w
  ; ***
  paintCircle( x, y, w / 2, c, 1, #True )
  ; ***
  sz = (w / 2)
  ; ***
  Line( x, y + sz, 1, h - sz, c )
  Line( x + w, y + sz, 1, h - sz + 1, c )
  ; ***
  Line( x + ww - mm, y + hh, 1, hh + 1, c )
  Line( x + ww + mm, y + hh, 1, hh, c )
  ; ***
  Line( x + ww - mm, y + hh, #mexsize, 1, c )
  ; ***
  Line( x, y + h, ww - mm, 1, c )
  Line( x + ww + mm, y + h, ww - mm, 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + w - ((ww - mm) / 2), y + hh - h2, 1, hh + h2, c )
  ; ***
  Line( x + ((ww - mm) / 2), y + hh - h2, w - ww + mm, 1, c )
  ; ***
  Circle( x + w - ((ww - mm) / 2), y + h - 6, 3, c )
  ; ***
  If IsImage( 1505 )
    xx = x +( ((ww - mm) / 2) ) - ( ImageWidth(1505) / 2)
    yy = y + h - ImageHeight(1505) - 1
    ; ***
    Line( xx + ( ImageWidth(1505) / 2), y + hh - h2, 1, hh + h2, c )
    ; ***
    DrawAlphaImage( ImageID( 1505 ), xx, yy + 1 )
  EndIf
EndProcedure

Procedure element_treppe_39( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  Protected sz.w
  ; ***
  paintCircle( x, y + h - (w - 2), w / 2, c, 2, #True )
  ; ***
  sz = (w / 2)
  ; ***
  Line( x, y, 1, h - sz + 2, c )
  Line( x + w, y, 1, h - sz + 2, c )
  ; ***
  Line( x + ww - mm, y, 1, hh, c )
  Line( x + ww + mm, y, 1, hh, c )
  ; ***
  Line( x + ww - mm, y + hh, #mexsize, 1, c )
  ; ***
  Line( x, y, ww - mm, 1, c )
  Line( x + ww + mm, y, ww - mm, 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + ((ww - mm) / 2), y + 3, 1, hh + h2, c )
  ; ***
  Line( x + ((ww - mm) / 2), y + h - h2 + 2, w - ww + mm, 1, c )
  ; ***
  Circle( x + ((ww - mm) / 2), y + 6, 3, c )
  ; ***
  If IsImage( 1504 )
    xx = x + w - ( ((ww - mm) / 2) ) - ( ImageWidth(1504) / 2)
    yy = y + 3
    ; ***
    Line( xx + ( ImageWidth(1504) / 2), y + 3, 1, hh + h2, c )
    ; ***
    DrawAlphaImage( ImageID( 1504 ), xx, yy - 1 )
  EndIf
EndProcedure

Procedure element_treppe_40( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  Protected sz.w
  ; ***
  paintCircle( x, y + h - (w - 2), w / 2, c, 2, #True )
  ; ***
  sz = (w / 2)
  ; ***
  Line( x, y, 1, h - sz + 2, c )
  Line( x + w, y, 1, h - sz + 2, c )
  ; ***
  Line( x + ww - mm, y, 1, hh, c )
  Line( x + ww + mm, y, 1, hh, c )
  ; ***
  Line( x + ww - mm, y + hh, #mexsize, 1, c )
  ; ***
  Line( x, y, ww - mm, 1, c )
  Line( x + ww + mm, y, ww - mm, 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + w - ((ww - mm) / 2), y + 3, 1, hh + h2, c )
  ; ***
  Line( x + ((ww - mm) / 2), y + h - h2 + 2, w - ww + mm, 1, c )
  ; ***
  Circle( x + w - ((ww - mm) / 2), y + 6, 3, c )
  ; ***
  If IsImage( 1504 )
    xx = x +( ((ww - mm) / 2) ) - ( ImageWidth(1505) / 2)
    yy = y + 3
    ; ***
    Line( xx + ( ImageWidth(1504) / 2), y + 3, 1, hh + h2, c )
    ; ***
    DrawAlphaImage( ImageID( 1504 ), xx, yy - 1 )
  EndIf
EndProcedure

Procedure element_treppe_41( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  Protected sz.w
  ; ***
  paintCircle( x, y, h / 2, c, 3, #True )
  ; ***
  sz = (h / 2)
  ; ***
  Line( x + sz, y, w - sz, 1, c )
  Line( x + sz, y + h, w - sz + 1, 1, c )
  ; ***
  Line( x + ww, y + hh - mm, ww, 1, c )
  Line( x + ww, y + hh + mm, ww, 1, c )
  ; ***
  Line( x + ww, y + hh - mm, 1, #mexsize, c )
  ; ***
  Line( x + w, y, 1, hh - mm + 1, c )
  Line( x + w, y + hh + mm, 1, hh - mm + 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + w2, y + h - ((hh - mm) / 2), ww + w2 - 3, 1, c )
  Line( x + w2, y + ((hh - mm) / 2), ww + w2 - 3, 1, c )
  ; ***
  Line( x + w2, y + ((hh - mm) / 2), 1, h - hh + mm, c )
  ; ***
  Circle( x + w - 6, y + ((hh - mm) / 2), 3, c )
  ; ***
  If IsImage( 1507 )
    xx = x + w - ImageWidth(1507) - 1
    yy = y + h - ( ((hh - mm) / 2) ) - ( ImageHeight(1507) / 2)
    ; ***
    DrawAlphaImage( ImageID( 1507 ), xx, yy - 1 )
  EndIf
EndProcedure

Procedure element_treppe_42( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  Protected sz.w
  ; ***
  paintCircle( x, y, h / 2, c, 3, #True )
  ; ***
  sz = (h / 2)
  ; ***
  Line( x + sz, y, w - sz, 1, c )
  Line( x + sz, y + h, w - sz + 1, 1, c )
  ; ***
  Line( x + ww, y + hh - mm, ww, 1, c )
  Line( x + ww, y + hh + mm, ww, 1, c )
  ; ***
  Line( x + ww, y + hh - mm, 1, #mexsize, c )
  ; ***
  Line( x + w, y, 1, hh - mm + 1, c )
  Line( x + w, y + hh + mm, 1, hh - mm + 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + w2, y + h - ((hh - mm) / 2), ww + w2 - 3, 1, c )
  Line( x + w2, y + ((hh - mm) / 2), ww + w2 - 3, 1, c )
  ; ***
  Line( x + w2, y + ((hh - mm) / 2), 1, h - hh + mm, c )
  ; ***
  Circle( x + w - 6, y + h - ((hh - mm) / 2), 3, c )
  ; ***
  If IsImage( 1507 )
    xx = x + w - ImageWidth(1507) - 1
    yy = y + ((hh - mm) / 2) - ( ImageHeight(1507) / 2)
    ; ***
    DrawAlphaImage( ImageID( 1507 ), xx, yy - 1 )
  EndIf
EndProcedure

Procedure element_treppe_43( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  Protected sz.w
  ; ***
  paintCircle( x + w - h, y, h / 2, c, 4, #True )
  ; ***
  sz = (h / 2)
  ; ***
  Line( x, y, w - sz + 1, 1, c )
  Line( x, y + h, w - sz + 1, 1, c )
  ; ***
  Line( x, y + hh - mm, ww + 1, 1, c )
  Line( x, y + hh + mm, ww + 1, 1, c )
  ; ***
  Line( x + ww, y + hh - mm, 1, #mexsize, c )
  ; ***
  Line( x, y, 1, hh - mm + 1, c )
  Line( x, y + hh + mm, 1, hh - mm + 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + 3, y + h - ((hh - mm) / 2), ww + w2 - 3, 1, c )
  Line( x + 5, y + ((hh - mm) / 2), ww + w2 - 5, 1, c )
  ; ***
  Line( x + ww + w2, y + ((hh - mm) / 2), 1, h - hh + mm + 1, c )
  ; ***
  Circle( x + 6, y + ((hh - mm) / 2), 3, c )
  ; ***
  If IsImage( 1506 )
    xx = x + 2
    yy = y + h - ( ((hh - mm) / 2) ) - ( ImageHeight(1506) / 2)
    ; ***
    DrawAlphaImage( ImageID( 1506 ), xx, yy - 1 )
  EndIf
EndProcedure

Procedure element_treppe_44( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  Protected sz.w
  ; ***
  paintCircle( x + w - h, y, h / 2, c, 4, #True )
  ; ***
  sz = (h / 2)
  ; ***
  Line( x, y, w - sz + 1, 1, c )
  Line( x, y + h, w - sz + 1, 1, c )
  ; ***
  Line( x, y + hh - mm, ww + 1, 1, c )
  Line( x, y + hh + mm, ww + 1, 1, c )
  ; ***
  Line( x + ww, y + hh - mm, 1, #mexsize, c )
  ; ***
  Line( x, y, 1, hh - mm + 1, c )
  Line( x, y + hh + mm, 1, hh - mm + 1, c )
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Line( x + 3, y + h - ((hh - mm) / 2), ww + w2 - 3, 1, c )
  Line( x + 5, y + ((hh - mm) / 2), ww + w2 - 5, 1, c )
  ; ***
  Line( x + ww + w2, y + ((hh - mm) / 2), 1, h - hh + mm + 1, c )
  ; ***
  Circle( x + 6, y + h - ((hh - mm) / 2), 3, c )
  ; ***
  If IsImage( 1506 )
    xx = x + 2
    yy = y + ( ((hh - mm) / 2) ) - ( ImageHeight(1506) / 2)
    ; ***
    DrawAlphaImage( ImageID( 1506 ), xx, yy - 1 )
  EndIf
EndProcedure

Procedure element_treppe_45( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  Protected sz.w
  Protected wm.d = w / 100, hm.d = (w / 2) / 100
  ; ***
  paintCircle( x, y, w / 2, c, 0, #True )
  paintCircle( x + (w / 4), y + (w / 4), w / 4, c, 0, #True )
  paintCircle( x + (w / 2) - (w / 12), y + (w / 2) - (w / 12), w / 12, c, 0, #True )
  ; ***
  sz = (h / 2)
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
;  Circle( x + (wm * 28), y + (hm * 75), 3, c )
  Circle( x + w - (wm * 28), y + (hm * 120), 3, c )
  ; ***
;  LineXY( x + w - ww, y + ww, x + ww, y + h, c )
;  LineXY( x + w - ww, y + ww, x, y + h, c )
  ; ***
  If IsImage( 1505 )
    xx = x + (wm * 24)
    yy = y + (hm * 110)
    ; ***
    DrawAlphaImage( ImageID( 1505 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_46( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  Protected sz.w
  Protected wm.d = w / 100, hm.d = (w / 2) / 100
  ; ***
  paintCircle( x, y, w / 2, c, 0, #True )
  paintCircle( x + (w / 4), y + (w / 4), w / 4, c, 0, #True )
  paintCircle( x + (w / 2) - (w / 12), y + (w / 2) - (w / 12), w / 12, c, 0, #True )
  ; ***
  sz = (h / 2)
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + (wm * 27), y + (hm * 120), 3, c )
  ; ***
;  Line( x + w - ww, y + ww, ww, 1, c )
;  Line( x + w - ww, y + ww, 1, ww, c )
  ; ***
  If IsImage( 1505 )
    xx = x + w - (wm * 30)
    yy = y + (hm * 120)
    ; ***
    DrawAlphaImage( ImageID( 1505 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_47( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  Protected sz.w
  Protected wm.d = w / 100, hm.d = (w / 2) / 100
  ; ***
  paintCircle( x, y, w / 2, c, 0, #True )
  paintCircle( x + (w / 4), y + (w / 4), w / 4, c, 0, #True )
  paintCircle( x + (w / 2) - (w / 12), y + (w / 2) - (w / 12), w / 12, c, 0, #True )
  ; ***
  sz = (h / 2)
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + w - (wm * 35), y + (hm * 140), 3, c )
  ; ***
;  Line( x + w - ww, y + ww, ww, 1, c )
;  Line( x + w - ww, y + ww, 1, ww, c )
  ; ***
  If IsImage( 1507 )
    xx = x + w - (wm * 40)
    yy = y + (hm * 50)
    ; ***
    DrawAlphaImage( ImageID( 1507 ), xx, yy )
  EndIf
EndProcedure

Procedure element_treppe_48( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  Protected sz.w
  Protected wm.d = w / 100, hm.d = (w / 2) / 100
  ; ***
  paintCircle( x, y, w / 2, c, 0, #True )
  paintCircle( x + (w / 4), y + (w / 4), w / 4, c, 0, #True )
  paintCircle( x + (w / 2) - (w / 12), y + (w / 2) - (w / 12), w / 12, c, 0, #True )
  ; ***
  sz = (h / 2)
  ; ***
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Circle( x + (wm * 35), y + (hm * 140), 3, c )
  ; ***
;  Line( x + w - ww, y + ww, ww, 1, c )
;  Line( x + w - ww, y + ww, 1, ww, c )
  ; ***
  If IsImage( 1506 )
    xx = x + (wm * 40)
    yy = y + (hm * 50)
    ; ***
    DrawAlphaImage( ImageID( 1506 ), xx, yy )
  EndIf
EndProcedure






Procedure element_aufzug_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  ; ***
  Box( x, y, w, h - h2, c )
  ; ***
  LineXY( x, y, x + w, y + h - h2, c )
  LineXY( x + w, y, x, y + h - h2, c )
  ; ***
  Line( x + w2, y + h - h2, 1, h2, c )
  Line( x + w - w2, y + h - h2, 1, h2, c )
  ; ***
  LineXY( x + w2, y + h, x + w2 + w2, y + h - h2, c )
  ; ***
  LineXY( x + w2 + w2 + w2, y + h, x + w2 + w2, y + h - h2, c )
  ; ***
  xx = w / 2
  xx + x
  ; ***
  yy = y + h - h2 - 2
  ; ***
  Line( xx, yy, 1, 1, c )
  Line( xx - 1, yy - 1, 3, 1, c )
  Line( xx - 2, yy - 2, 5, 1, c )
  Line( xx - 3, yy - 3, 7, 1, c )
  Line( xx - 4, yy - 4, 9, 1, c )
  Line( xx - 5, yy - 5,11, 1, c )
EndProcedure

Procedure element_aufzug_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  ; ***
  Box( x, y, w - w2, h, c )
  ; ***
  LineXY( x, y, x + w - w2, y + h, c )
  LineXY( x, y + h, x + w - w2, y, c )
  ; ***
  Line( x + w - w2, y + h2, w2, 1, c )
  Line( x + w - w2, y + h - h2, w2, 1, c )
  ; ***
  LineXY( x + w, y + h2, x + w - w2, y + h2 + h2, c )
  ; ***
  LineXY( x + w, y + h2 + h2 + h2, x + w - w2, y + h2 + h2, c )
  ; ***
  xx = w - w2 - 2
  xx + x
  ; ***
  yy = y + hh
  ; ***
  Line( xx, yy, 1, 1, c )
  Line( xx - 1, yy - 1, 1, 3, c )
  Line( xx - 2, yy - 2, 1, 5, c )
  Line( xx - 3, yy - 3, 1, 7, c )
  Line( xx - 4, yy - 4, 1, 9, c )
  Line( xx - 5, yy - 5, 1,11, c )
EndProcedure

Procedure element_aufzug_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  ; ***
  Box( x, y + h2, w, h - h2, c )
  ; ***
  LineXY( x, y + h2, x + w, y + h, c )
  LineXY( x + w, y + h2, x, y + h, c )
  ; ***
  Line( x + w2, y, 1, h2, c )
  Line( x + w - w2, y, 1, h2, c )
  ; ***
  LineXY( x + w2, y, x + w2 + w2, y + h2, c )
  ; ***
  LineXY( x + w2 + w2 + w2, y, x + w2 + w2, y + h2, c )
  ; ***
  xx = w / 2
  xx + x
  ; ***
  yy = y + h2 + 2
  ; ***
  Line( xx, yy, 1, 1, c )
  Line( xx - 1, yy + 1, 3, 1, c )
  Line( xx - 2, yy + 2, 5, 1, c )
  Line( xx - 3, yy + 3, 7, 1, c )
  Line( xx - 4, yy + 4, 9, 1, c )
  Line( xx - 5, yy + 5,11, 1, c )
EndProcedure

Procedure element_aufzug_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 ), p.w, g.w
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 4, h2.w = h / 4
  Protected xx.w, yy.w, mm.w = #mexsize / 2
  ; ***
  Box( x + w2, y, w - w2, h, c )
  ; ***
  LineXY( x + w2, y, x + w, y + h, c )
  LineXY( x + w2, y + h, x + w, y, c )
  ; ***
  Line( x, y + h2, w2, 1, c )
  Line( x, y + h - h2, w2, 1, c )
  ; ***
  LineXY( x, y + h2, x + w2, y + h2 + h2, c )
  ; ***
  LineXY( x, y + h2 + h2 + h2, x + w2, y + h2 + h2, c )
  ; ***
  xx = w2 + 2
  xx + x
  ; ***
  yy = y + hh
  ; ***
  Line( xx, yy, 1, 1, c )
  Line( xx + 1, yy - 1, 1, 3, c )
  Line( xx + 2, yy - 2, 1, 5, c )
  Line( xx + 3, yy - 3, 1, 7, c )
  Line( xx + 4, yy - 4, 1, 9, c )
  Line( xx + 5, yy - 5, 1,11, c )
EndProcedure

Procedure element_kamin( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 )
  Protected n.d, m.d
  ; ***
  n = h / 2
  m = w / 2
  ; ***
  n / 2
  m / 2
  ; ***
  Box( x, y, w, h, c )
  ; ***
  LineXY( x, y, x + w, y + h, c )
  LineXY( x + w, y, x, y + h, c )
  ; ***
  Ellipse( x + ( w - m) - m, y + (h - n) - n, w / 2, h / 2, c )
EndProcedure

Procedure element_fenster_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Box( x, y, w, h, RGB( 255, 255, 255 ) )
  ; ***
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Box( x, y, w, h, RGB( 0, 0, 0 ) )
  ; ***
  Box( x, y + (h / 2), w, 1, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + (w / 2), y, 1, h, RGB( 0, 0, 0 ) )
EndProcedure

Procedure element_fenster_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Box( x, y, w, h, RGB( 255, 255, 255 ) )
  ; ***
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Box( x, y, w, h, RGB( 0, 0, 0 ) )
  ; ***
  Box( x + (w / 2), y, 1, h, RGB( 0, 0, 0 ) )
  ; ***
  Box( x, y + (h / 2), w, 1, RGB( 0, 0, 0 ) )
EndProcedure

Procedure element_stuetze_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected c.l = RGB( 0, 0, 0 )
  Protected n.d, m.d
  ; ***
  n = h / 2
  m = w / 2
  ; ***
  n / 2
  m / 2
  ; ***
  Box( x, y, w, h, c )
  ; ***
  LineXY( x, y, x + w, y + h, c )
  LineXY( x + w, y, x, y + h, c )
EndProcedure

Procedure element_stuetze_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected ww.d = w / 2, hh.d = h / 2, w2.w = w / 6, h2.w = h / 6
  Protected c.l = RGB( 0, 0, 0 )
  Protected n.d, m.d
  ; ***
  n = h / 2
  m = w / 2
  ; ***
  n / 2
  m / 2
  ; ***
  LineXY( x + w2, y + h2, x + w - w2, y + h - h2, c )
  LineXY( x + w - w2, y + h2, x + w2, y + h - h2, c )
  ; ***
  Ellipse( x + ( w - m) - m, y + (h - n) - n, w / 2, h / 2, c )
EndProcedure

Procedure element_door_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected n.d, sz.w = 0, ps.w = w / 2, c.l = RGB( 0, 0, 0 )
  ; ***
  Box( x + w, y, 1, h - sz + 1, c )
  Box( x, y + h - sz, w, 1, c )
  ; ***
  LineXY( x + w, y, x, y + h - sz, c )
  ; ***
  FillArea( x + w - 2, y + h - sz - 2, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  ; ***
  Box( x + ps, y + h - sz + 2, 1, 1, c )
  Box( x + ps - 1, y + h - sz + 3, 3, 1, c )
  Box( x + ps - 2, y + h - sz + 4, 5, 1, c )
  Box( x + ps - 3, y + h - sz + 5, 7, 1, c )
  Box( x + ps - 4, y + h - sz + 6, 9, 1, c )
  Box( x + ps - 5, y + h - sz + 7,11, 1, c )
EndProcedure

Procedure element_door_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected n.d, sz.w = 0, ps.w = w / 2, c.l = RGB( 0, 0, 0 )
  ; ***
  Box( x, y, 1, h - sz + 1, RGB( 0, 0, 0 ) )
  Box( x, y + h - sz, w, 1, RGB( 0, 0, 0 ) )
  ; ***
  LineXY( x, y, x + w, y + h - sz, RGB( 0, 0, 0 ) )
  ; ***
  FillArea( x + 2, y + h - sz - 2, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  ; ***
  Box( x + ps, y + h - sz + 2, 1, 1, c )
  Box( x + ps - 1, y + h - sz + 3, 3, 1, c )
  Box( x + ps - 2, y + h - sz + 4, 5, 1, c )
  Box( x + ps - 3, y + h - sz + 5, 7, 1, c )
  Box( x + ps - 4, y + h - sz + 6, 9, 1, c )
  Box( x + ps - 5, y + h - sz + 7,11, 1, c )
EndProcedure

Procedure element_door_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected n.d, sz.w = #mexsize, ps.w = w / 2, c.l = RGB( 0, 0, 0 )
  ; ***
  Box( x, y + sz, 1, h - sz + 1, RGB( 0, 0, 0 ) )
  Box( x, y + sz, w, 1, RGB( 0, 0, 0 ) )
  ; ***
  LineXY( x + w, y + sz, x, y + h, RGB( 0, 0, 0 ) )
  ; ***
  FillArea( x + 2, y + 2 + #mexsize, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  ; ***
  Box( x + ps - 5, y + sz - 7, 11, 1, c )
  Box( x + ps - 4, y + sz - 6,  9, 1, c )
  Box( x + ps - 3, y + sz - 5,  7, 1, c )
  Box( x + ps - 2, y + sz - 4,  5, 1, c )
  Box( x + ps - 1, y + sz - 3,  3, 1, c )
  Box( x + ps    , y + sz - 2,  1, 1, c )
EndProcedure

Procedure element_door_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected n.d, sz.w = #mexsize, ps.w = w / 2, c.l = RGB( 0, 0, 0 )
  ; ***
  Box( x + w, y + sz, 1, h - sz + 1, RGB( 0, 0, 0 ) )
  Box( x, y + sz, w, 1, RGB( 0, 0, 0 ) )
  ; ***
  LineXY( x, y + sz, x + w, y + h, RGB( 0, 0, 0 ) )
  ; ***
  FillArea( x + w - 2, y + 2 + #mexsize, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  ; ***
  Box( x + ps - 5, y + sz - 7, 11, 1, c )
  Box( x + ps - 4, y + sz - 6,  9, 1, c )
  Box( x + ps - 3, y + sz - 5,  7, 1, c )
  Box( x + ps - 2, y + sz - 4,  5, 1, c )
  Box( x + ps - 1, y + sz - 3,  3, 1, c )
  Box( x + ps    , y + sz - 2,  1, 1, c )
EndProcedure

Procedure element_door_5( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected n.d, sz.w = #mexsize, ps.w = w - 6, c.l = RGB( 0, 0, 0 )
  ; ***
  Box( x, y, w - sz + 1, 1, c )
  Box( x + w - sz, y, 1, h, c )
  ; ***
  LineXY( x, y, x + w - sz, y + h, c )
  ; ***
  FillArea( x + w - #mexsize - 4, y + 2, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  ; ***
  ps - #mexsize + 8
  ; ***
  Box( x + ps, y + (h / 2),         1, 1, c )
  Box( x + ps + 1, y + (h / 2) - 1, 1, 3, c )
  Box( x + ps + 2, y + (h / 2) - 2, 1, 5, c )
  Box( x + ps + 3, y + (h / 2) - 3, 1, 7, c )
  Box( x + ps + 4, y + (h / 2) - 4, 1, 9, c )
  Box( x + ps + 5, y + (h / 2) - 5, 1,11, c )
EndProcedure

Procedure element_door_6( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected n.d, sz.w = #mexsize, ps.w = w - 6, c.l = RGB( 0, 0, 0 )
  ; ***
  Box( x, y + h, w - sz + 1, 1, c )
  Box( x + w - sz, y, 1, h, c )
  ; ***
  LineXY( x, y + h, x + w - sz, y, c )
  ; ***
  FillArea( x + w - #mexsize - 4, y + h - 2, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  ; ***
  ps - #mexsize + 8
  ; ***
  Box( x + ps, y + (h / 2),         1, 1, c )
  Box( x + ps + 1, y + (h / 2) - 1, 1, 3, c )
  Box( x + ps + 2, y + (h / 2) - 2, 1, 5, c )
  Box( x + ps + 3, y + (h / 2) - 3, 1, 7, c )
  Box( x + ps + 4, y + (h / 2) - 4, 1, 9, c )
  Box( x + ps + 5, y + (h / 2) - 5, 1,11, c )
EndProcedure

Procedure element_door_7( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected n.d, sz.w = #mexsize, ps.w = 5, c.l = RGB( 0, 0, 0 )
  ; ***
  Box( x + sz, y, w - sz + 1, 1, c )
  Box( x + sz, y, 1, h, c )
  ; ***
  LineXY( x + w, y, x + sz, y + h, c )
  ; ***
  FillArea( x + w - #mexsize - 4, y + 2, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  ; ***
  ps = #mexsize - 2
  ; ***
  Box( x + ps, y + (h / 2),         1, 1, c )
  Box( x + ps - 1, y + (h / 2) - 1, 1, 3, c )
  Box( x + ps - 2, y + (h / 2) - 2, 1, 5, c )
  Box( x + ps - 3, y + (h / 2) - 3, 1, 7, c )
  Box( x + ps - 4, y + (h / 2) - 4, 1, 9, c )
  Box( x + ps - 5, y + (h / 2) - 5, 1,11, c )
EndProcedure

Procedure element_door_8( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected n.d, sz.w = #mexsize, ps.w = 5, c.l = RGB( 0, 0, 0 )
  ; ***
  Box( x + sz, y + h, w - sz + 1, 1, c )
  Box( x + sz, y, 1, h, c )
  ; ***
  LineXY( x + sz, y, x + w, y + h, c )
  ; ***
  FillArea( x + w - #mexsize - 4, y + h - 2, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  ; ***
  ps = #mexsize - 2
  ; ***
  Box( x + ps, y + (h / 2),         1, 1, c )
  Box( x + ps - 1, y + (h / 2) - 1, 1, 3, c )
  Box( x + ps - 2, y + (h / 2) - 2, 1, 5, c )
  Box( x + ps - 3, y + (h / 2) - 3, 1, 7, c )
  Box( x + ps - 4, y + (h / 2) - 4, 1, 9, c )
  Box( x + ps - 5, y + (h / 2) - 5, 1,11, c )
EndProcedure

Procedure element_door_9( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected n.d, sz.w = 0, ps.w = w / 2, c.l = RGB( 0, 0, 0 )
  Protected ww.w = w / 2
  ; ***
  Box( x + w, y, 1, h - sz + 1, c )
  Box( x, y, 1, h - sz + 1, c )
  Box( x, y + h - sz, w, 1, c )
  ; ***
  LineXY( x, y, x + ww, y + h - sz, c )
  LineXY( x + w, y, x + ww, y + h - sz, c )
  ; ***
  FillArea( x + w - #mexsize - 4, y + h - 2, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  FillArea( x + 4, y + h - 2, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  ; ***
  Box( x + ps, y + h - sz + 2, 1, 1, c )
  Box( x + ps - 1, y + h - sz + 3, 3, 1, c )
  Box( x + ps - 2, y + h - sz + 4, 5, 1, c )
  Box( x + ps - 3, y + h - sz + 5, 7, 1, c )
  Box( x + ps - 4, y + h - sz + 6, 9, 1, c )
  Box( x + ps - 5, y + h - sz + 7,11, 1, c )
EndProcedure

Procedure element_door_10( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected n.d, sz.w = #mexsize, ps.w = w / 2, c.l = RGB( 0, 0, 0 )
  Protected ww.w = w / 2
  ; ***
  Box( x + w, y + sz, 1, h - sz + 1, c )
  Box( x, y + sz, 1, h - sz + 1, c )
  Box( x, y + sz, w, 1, c )
  ; ***
  LineXY( x + ww, y + sz, x, y + h, c )
  LineXY( x + ww, y + sz, x + w, y + h, c )
  ; ***
  FillArea( x + w - #mexsize - 4, y + #mexsize + 2, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  FillArea( x + 4, y + #mexsize + 2, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  ; ***
  Box( x + ps,     y + sz - 2, 1, 1, c )
  Box( x + ps - 1, y + sz - 3, 3, 1, c )
  Box( x + ps - 2, y + sz - 4, 5, 1, c )
  Box( x + ps - 3, y + sz - 5, 7, 1, c )
  Box( x + ps - 4, y + sz - 6, 9, 1, c )
  Box( x + ps - 5, y + sz - 7,11, 1, c )
EndProcedure

Procedure element_door_11( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected n.d, sz.w = #mexsize, ps.w = w - 5, c.l = RGB( 0, 0, 0 )
  Protected ww.w = w / 2
  ; ***
  Box( x, y, w - sz + 1, 1, c )
  Box( x, y + h, w - sz + 1, 1, c )
  Box( x + w - sz, y, 1, h, c )
  ; ***
  LineXY( x, y, x + w - sz, y + (h / 2), c )
  LineXY( x + w - sz, y + (h / 2), x, y + h, c )
  ; ***
  FillArea( x + w - #mexsize - 4, y + 2, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  FillArea( x + w - #mexsize - 4, y + h - 2, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  ; ***
  ps = w - #mexsize + 2
  ; ***
  Box( x + ps,     y - 0 + (h / 2), 1, 1, c )
  Box( x + ps + 1, y - 1 + (h / 2), 1, 3, c )
  Box( x + ps + 2, y - 2 + (h / 2), 1, 5, c )
  Box( x + ps + 3, y - 3 + (h / 2), 1, 7, c )
  Box( x + ps + 4, y - 4 + (h / 2), 1, 9, c )
  Box( x + ps + 5, y - 5 + (h / 2), 1,11, c )
EndProcedure

Procedure element_door_12( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Protected n.d, sz.w = #mexsize, ps.w = 5, c.l = RGB( 0, 0, 0 )
  Protected ww.w = w / 2
  ; ***
  Box( x + sz, y, w + 1 - sz, 1, c )
  Box( x + sz, y + h, w + 1 - sz, 1, c )
  Box( x + sz, y, 1, h, c )
  ; ***
  LineXY( x + sz, y + (h / 2), x + w, y, c )
  LineXY( x + sz, y + (h / 2), x + w, y + h, c )
  ; ***
  FillArea( x + #mexsize + 4, y + 2, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  FillArea( x + #mexsize + 4, y + h - 2, RGB( 0, 0, 0 ), RGB( 255, 255, 255 ) )
  ; ***
  ps = #mexsize - 2
  ; ***
  Box( x + ps,     y - 0 + (h / 2), 1, 1, c )
  Box( x + ps - 1, y - 1 + (h / 2), 1, 3, c )
  Box( x + ps - 2, y - 2 + (h / 2), 1, 5, c )
  Box( x + ps - 3, y - 3 + (h / 2), 1, 7, c )
  Box( x + ps - 4, y - 4 + (h / 2), 1, 9, c )
  Box( x + ps - 5, y - 5 + (h / 2), 1,11, c )
EndProcedure

Procedure element_door_13( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  drawHalfCircle( x, y, w, 4, RGB(0,0,0) )
  ; ***
  drawHalfCircle( x + 3, y + 3, w - 5, 4, RGB(255,255,255) )
  ; ***
  Box( x + 2, y + h - 2, w - 4, 2, RGB( 255, 255, 255 ) )
EndProcedure

Procedure element_door_14( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected w1.w = w
  Protected w2.w = w - 5
  ; ***
  drawHalfCircle( x - w1, y - w1, w, 7, RGB(0,0,0) )
  ; ***
  drawHalfCircle( x + 2 - w2, y + 3 - w2, w - 5, 7, RGB(255,255,255) )
  ; ***
  Box( x + 2, y, w - 4, 3, RGB( 255, 255, 255 ) )
EndProcedure

Procedure element_door_15( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected w1.w = w
  Protected w2.w = w - 5
  ; ***
  drawHalfCircle( x, y - w1, w, 5, RGB(0,0,0) )
  ; ***
  drawHalfCircle( x + 3, y + 3 - w2, w - 5, 5, RGB(255,255,255) )
  ; ***
  Box( x + 2, y + 2, w - 2, 1, RGB( 255, 255, 255 ) )
  ; ***
  Box( x + w - 2, y + 2, 2, h - 4, RGB( 255, 255, 255 ) )
EndProcedure

Procedure element_dachshregen_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected p.l, n.w = 0
  ; ***
  For p = x To x + w - 1 Step 20
    Box( x + (n * 20), y, 14, 2, RGB( 0, 0, 0 ) )
    ; ***
    Box( x + (n * 20), y + h - 1, 14, 2, RGB( 0, 0, 0 ) )
    ; ***
    n + 1
  Next
EndProcedure

Procedure element_dachshregen_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected p.l, n.w = 0
  ; ***
  For p = x To x + h - 1 Step 20
    Box( x, y + (n * 20), 2, 14, RGB( 0, 0, 0 ) )
    ; ***
    Box( x + w - 1, y + (n * 20), 2, 14, RGB( 0, 0, 0 ) )
    ; ***
    n + 1
  Next
EndProcedure

Procedure element_dachshregen_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected p.l
  ; ***
  Box( x, y, w, h, RGB( 255, 255, 255 ) )
  ; ***
  For p = x To x + w - 1 Step 4
    Box( p, y, 1, h, RGB( 0, 0, 0 ) )
  Next
EndProcedure

Procedure element_dachshregen_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected p.l
  ; ***
  Box( x, y, w, h, RGB( 255, 255, 255 ) )
  ; ***
  For p = y To y + h - 1 Step 4
    Box( x, p, w, 1, RGB( 0, 0, 0 ) )
  Next
EndProcedure

Procedure element_flaster( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  ; nix
EndProcedure

Procedure element_dline( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected *item.gui_visual_measure_item_struct = *obj
  ; ***
  If *item
    With *item
      DrawingMode( #PB_2DDrawing_Default )
      ; ***
      ;LineXY( x + \x1, y + \y1, x + w - \x2, y + h - \y2, RGB( 0, 0, 0 ) )
      ;LineXY( x + \x1, y + \y1, x + \x2, y + \y2, RGB( 0, 0, 0 ) )
      ;_guivmr_eline( x + \x1, y + \y1, x + w + \x2, y + h + \y2, RGB( 0, 0, 0 ), \etop )
      _guivmr_eline( x + \x1, y + \y1, x + w - \x2, y + h - \y2, RGB( 0, 0, 0 ), \etop )
    EndWith
  EndIf
EndProcedure

Procedure element_hline( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  If *obj
    Protected *itm.gui_visual_measure_item_struct = *obj
    ; ***
    If *itm
      With *itm
        Box( x, y, w, 1 + \etop, RGB( 0, 0, 0 ) )
      EndWith
    EndIf
  EndIf
EndProcedure

Procedure element_vline( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  If *obj
    Protected *itm.gui_visual_measure_item_struct = *obj
    ; ***
    If *itm
      With *itm
        Box( x, y, 1 + \etop, h, RGB( 0, 0, 0 ) )
      EndWith
    EndIf
  EndIf
EndProcedure

Procedure element_arrow_up( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.w, r.w = w / 2, c.l = RGB( 0, 0, 0 )
  ; ***
  LineXY( x + r, y, x, y + h, c )
  LineXY( x + r, y, x + w, y + h, c )
  Box( x, y + h, w, 1, c )
  ; ***
  FillArea( x + (w / 2), y + (h / 2), c, c )
EndProcedure

Procedure element_arrow_down( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.w, r.w = w / 2, c.l = RGB( 0, 0, 0 )
  ; ***
  LineXY( x + r, y + h, x, y, c )
  LineXY( x + r, y + h, x + w, y, c )
  Box( x, y, w, 1, c )
  ; ***
  FillArea( x + (w / 2), y + (h / 2), c, c )
EndProcedure

Procedure element_arrow_left( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.w, r.w = h / 2, c.l = RGB( 0, 0, 0 )
  ; ***
  LineXY( x, y + r, x + w, y, c )
  LineXY( x, y + r, x + w, y + h, c )
  Box( x + w, y, 1, h, c )
  ; ***
  FillArea( x + (w / 2), y + (h / 2), c, c )
EndProcedure

Procedure element_arrow_right( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.w, r.w = h / 2, c.l = RGB( 0, 0, 0 )
  ; ***
  LineXY( x + w, y + r, x, y, c )
  LineXY( x + w, y + r, x, y + h, c )
  Box( x, y, 1, h, c )
  ; ***
  FillArea( x + (w / 2), y + (h / 2), c, c )
EndProcedure

Procedure element_arrow_up_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.w, r.w = w / 2, c.l = RGB( 0, 0, 0 )
  ; ***
  LineXY( x + r, y, x, y + h, c )
  LineXY( x + r, y, x + w, y + h, c )
  Box( x, y + h, w, 1, c )
EndProcedure

Procedure element_arrow_down_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.w, r.w = w / 2, c.l = RGB( 0, 0, 0 )
  ; ***
  LineXY( x + r, y + h, x, y, c )
  LineXY( x + r, y + h, x + w, y, c )
  Box( x, y, w, 1, c )
EndProcedure

Procedure element_arrow_left_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.w, r.w = h / 2, c.l = RGB( 0, 0, 0 )
  ; ***
  LineXY( x, y + r, x + w, y, c )
  LineXY( x, y + r, x + w, y + h, c )
  Box( x + w, y, 1, h, c )
EndProcedure

Procedure element_arrow_right_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Protected n.w, r.w = h / 2, c.l = RGB( 0, 0, 0 )
  ; ***
  LineXY( x + w, y + r, x, y, c )
  LineXY( x + w, y + r, x, y + h, c )
  Box( x, y, 1, h, c )
EndProcedure

Procedure element_wand_v_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Box( x, y, #mexsize, h, RGB( 0, 0, 0 ) )
EndProcedure

Procedure element_wand_v_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Box( x, y, #mexsize * 2, h, RGB( 0, 0, 0 ) )
EndProcedure

Procedure element_wand_v_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Box( x, y, #mexsize * 3, h, RGB( 0, 0, 0 ) )
EndProcedure

Procedure element_wand_h_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Box( x, y, w, #mexsize, RGB( 0, 0, 0 ) )
EndProcedure

Procedure element_wand_h_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Box( x, y, w, #mexsize * 2, RGB( 0, 0, 0 ) )
EndProcedure

Procedure element_wand_h_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Default )
  ; ***
  Box( x, y, w, #mexsize * 3, RGB( 0, 0, 0 ) )
EndProcedure

Procedure element_mseinheit_1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  If *obj
    Protected *itm.gui_visual_measure_item_struct = *obj, yy.l, ww.l, t.s = "", d.s = "", e.s = "", f.s = ""
    ; ***
    If *itm
      With *itm
        DrawingMode( #PB_2DDrawing_Transparent )
        ; ***
        t = Trim(pick(0,";",\label))
        ; ***
        yy = y + ( ( h - TextHeight("A") ) / 2 )
        ; ***
        If t
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : t + " mm"
                  Case 2 : t + " cm"
                  Case 3 : t + " dm"
                  Case 4 : t + " m"
                  Case 5 : t + " in"
                  Case 6 : t + " pt"
                  Case 7 : t + " px"
                EndSelect
              EndIf
            Case 1 : t + " mm"
            Case 2 : t + " cm"
            Case 3 : t + " dm"
            Case 4 : t + " m"
            Case 5 : t + " in"
            Case 6 : t + " pt"
            Case 7 : t + " px"
          EndSelect
        EndIf
        ; ***
        d = Trim(pick(1,";",\label))
        ; ***
        If d
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : d + " mm"
                  Case 2 : d + " cm"
                  Case 3 : d + " dm"
                  Case 4 : d + " m"
                  Case 5 : d + " in"
                  Case 6 : d + " pt"
                  Case 7 : d + " px"
                EndSelect
              EndIf
            Case 1 : d + " mm"
            Case 2 : d + " cm"
            Case 3 : d + " dm"
            Case 4 : d + " m"
            Case 5 : d + " in"
            Case 6 : d + " pt"
            Case 7 : d + " px"
          EndSelect
        EndIf
        ; ***
        e = Trim(pick(2,";",\label))
        ; ***
        If e
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : e + " mm"
                  Case 2 : e + " cm"
                  Case 3 : e + " dm"
                  Case 4 : e + " m"
                  Case 5 : e + " in"
                  Case 6 : e + " pt"
                  Case 7 : e + " px"
                EndSelect
              EndIf
            Case 1 : e + " mm"
            Case 2 : e + " cm"
            Case 3 : e + " dm"
            Case 4 : e + " m"
            Case 5 : e + " in"
            Case 6 : e + " pt"
            Case 7 : e + " px"
          EndSelect
        EndIf
        ; ***
        f = Trim(pick(3,";",\label))
        ; ***
        If f
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : f + " mm"
                  Case 2 : f + " cm"
                  Case 3 : f + " dm"
                  Case 4 : f + " m"
                  Case 5 : f + " in"
                  Case 6 : f + " pt"
                  Case 7 : f + " px"
                EndSelect
              EndIf
            Case 1 : f + " mm"
            Case 2 : f + " cm"
            Case 3 : f + " dm"
            Case 4 : f + " m"
            Case 5 : f + " in"
            Case 6 : f + " pt"
            Case 7 : f + " px"
          EndSelect
        EndIf
        ; ***
        LineXY( x, y + h, x + w, y, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x + w - 5, y - 5, x + w + 5, y + 5, RGB( 0, 0, 0 ) )
        LineXY( x + w - 5, y + 5, x + w + 5, y - 5, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x - 5, y + h - 5, x + 5, y + h + 5, RGB( 0, 0, 0 ) )
        LineXY( x - 5, y + h + 5, x + 5, y + h - 5, RGB( 0, 0, 0 ) )
        ; ***
        If t
          ww = x - ( ( TextWidth(t) + 8 ) / 2 )
          ; ***
          Box( ww - 1 - 8, y - TextHeight(t) - 4 - #mexsize - 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
          Box( ww - 8, y - TextHeight(t) - 4 - #mexsize - 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
          ; ***
          DrawText( ww - 4, y - TextHeight(t) - 4 - #mexsize, t, RGB( 0, 0, 0 ) )
        EndIf
        ; ***
        If d
          ww = (x + w) + ( ( TextWidth(d) + 8 ) / 2 ) - ( TextWidth(d) + 8) + #mexsize
          ; ***
          Box( ww - 1 - 8, y - TextHeight(d) - 4 - #mexsize - 4, TextWidth(d) + 8, TextHeight(d) + 8, RGB( 0, 0, 0 ) )
          Box( ww - 8, y - TextHeight(d) - 4 - #mexsize - 4 + 1, TextWidth(d) + 8 - 2, TextHeight(d) + 8 - 2, RGB( 255, 255, 255 ) )
          ; ***
          DrawText( ww - 4, y - TextHeight(d) - 4 - #mexsize, d, RGB( 0, 0, 0 ) )
        EndIf
        ; ***
        If e
          ww = x - ( ( TextWidth(e) + 8 ) / 2 )
          ; ***
          Box( ww - 1 - 8, y + h + TextHeight(e) + 4 - 4, TextWidth(e) + 8, TextHeight(e) + 8, RGB( 0, 0, 0 ) )
          Box( ww - 8, y + h + TextHeight(e) + 4 - 4 + 1, TextWidth(e) + 8 - 2, TextHeight(e) + 8 - 2, RGB( 255, 255, 255 ) )
          ; ***
          DrawText( ww - 4, y + h + TextHeight(e) + 4, e, RGB( 0, 0, 0 ) )
        EndIf
        ; ***
        If f
          ww = (x + w) + ( ( TextWidth(f) + 8 ) / 2 ) - ( TextWidth(f) + 8) + #mexsize
          ; ***
          Box( ww - 1 - 8, y + h + TextHeight(f) + 4 - 4, TextWidth(f) + 8, TextHeight(f) + 8, RGB( 0, 0, 0 ) )
          Box( ww - 8, y + h + TextHeight(f) + 4 - 4 + 1, TextWidth(f) + 8 - 2, TextHeight(f) + 8 - 2, RGB( 255, 255, 255 ) )
          ; ***
          DrawText( ww - 4, y + h + TextHeight(f) + 4, f, RGB( 0, 0, 0 ) )
        EndIf
        ; ***
        LineXY( x, y, x + w, y + h, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x - 5, y - 5, x + 5, y + 5, RGB( 0, 0, 0 ) )
        LineXY( x - 5, y + 5, x + 5, y - 5, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x + w - 5, y + h - 5, x + w + 5, y + h + 5, RGB( 0, 0, 0 ) )
        LineXY( x + w - 5, y + h + 5, x + w + 5, y + h - 5, RGB( 0, 0, 0 ) )
      EndWith
    EndIf
  EndIf
EndProcedure

Procedure element_mseinheit_2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  If *obj
    Protected *itm.gui_visual_measure_item_struct = *obj, yy.l, t.s = ""
    ; ***
    If *itm
      With *itm
        DrawingMode( #PB_2DDrawing_Transparent )
        ; ***
        t = Trim(pick(0,";",\label))
        ; ***
        If t
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : t + " mm"
                  Case 2 : t + " cm"
                  Case 3 : t + " dm"
                  Case 4 : t + " m"
                  Case 5 : t + " in"
                  Case 6 : t + " pt"
                  Case 7 : t + " px"
                EndSelect
              EndIf
            Case 1 : t + " mm"
            Case 2 : t + " cm"
            Case 3 : t + " dm"
            Case 4 : t + " m"
            Case 5 : t + " in"
            Case 6 : t + " pt"
            Case 7 : t + " px"
          EndSelect
          ; ***
          yy = y + ( ( h - TextHeight(t) ) / 2 )
        EndIf
        ; ***
        Select \etop
          Case 0 To 19
            Box( x, y, 1, h, RGB( 0, 0, 0 ) )
            ; ***
            LineXY( x - 5, y - 5, x + 5, y + 5, RGB( 0, 0, 0 ) )
            LineXY( x - 5, y + 5, x + 5, y - 5, RGB( 0, 0, 0 ) )
            ; ***
            LineXY( x - 5, y + h - 5, x + 5, y + h + 5, RGB( 0, 0, 0 ) )
            LineXY( x - 5, y + h + 5, x + 5, y + h - 5, RGB( 0, 0, 0 ) )
            ; ***
            If t
              Box( x + #mexsize, yy - 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( x + #mexsize + 1, yy - 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( x + #mexsize + 4, yy, t, RGB( 0, 0, 0 ) )
            EndIf
          Default
            Box( x + w - 1, y, 1, h, RGB( 0, 0, 0 ) )
            ; ***
            LineXY( x + w - 1 - 5, y - 5, x + w - 1 + 5, y + 5, RGB( 0, 0, 0 ) )
            LineXY( x + w - 1 - 5, y + 5, x + w - 1 + 5, y - 5, RGB( 0, 0, 0 ) )
            ; ***
            LineXY( x + w - 1 - 5, y + h - 5, x + w - 1 + 5, y + h + 5, RGB( 0, 0, 0 ) )
            LineXY( x + w - 1 - 5, y + h + 5, x + w - 1 + 5, y + h - 5, RGB( 0, 0, 0 ) )
            ; ***
            If t
              Box( x + w - TextWidth(t) - #mexsize - #mexsize + 4, yy - 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( x + w - TextWidth(t) - #mexsize - #mexsize + 4 + 1, yy - 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( x + w - TextWidth(t) - #mexsize - #mexsize + 4 + 4, yy, t, RGB( 0, 0, 0 ) )
            EndIf
        EndSelect
      EndWith
    EndIf
  EndIf
EndProcedure

Procedure element_mseinheit_3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  If *obj
    Protected *itm.gui_visual_measure_item_struct = *obj, ww.l, t.s = ""
    ; ***
    If *itm
      With *itm
        DrawingMode( #PB_2DDrawing_Transparent )
        ; ***
        t = Trim(pick(0,";",\label))
        ; ***
        If t
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : t + " mm"
                  Case 2 : t + " cm"
                  Case 3 : t + " dm"
                  Case 4 : t + " m"
                  Case 5 : t + " in"
                  Case 6 : t + " pt"
                  Case 7 : t + " px"
                EndSelect
              EndIf
            Case 1 : t + " mm"
            Case 2 : t + " cm"
            Case 3 : t + " dm"
            Case 4 : t + " m"
            Case 5 : t + " in"
            Case 6 : t + " pt"
            Case 7 : t + " px"
          EndSelect
          ; ***
          ww = x + ( ( w - TextWidth(t) ) / 2 )
        EndIf
        ; ***
        Select \etop
          Case 0 To 19
            Box( x, y, w, 1, RGB( 0, 0, 0 ) )
            ; ***
            LineXY( x - 5, y - 5, x + 5, y + 5, RGB( 0, 0, 0 ) )
            LineXY( x - 5, y + 5, x + 5, y - 5, RGB( 0, 0, 0 ) )
            ; ***
            LineXY( x + w - 5, y - 5, x + w + 5, y + 5, RGB( 0, 0, 0 ) )
            LineXY( x + w - 5, y + 5, x + w + 5, y - 5, RGB( 0, 0, 0 ) )
            ; ***
            If t
              Box( ww, y + #mexsize, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( ww + 1, y + #mexsize + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( ww + 4, y + #mexsize + 4, t, RGB( 0, 0, 0 ) )
            EndIf
          Default
            Box( x, y + h, w, 1, RGB( 0, 0, 0 ) )
            ; ***
            LineXY( x - 5, y + h - 5, x + 5, y + h + 5, RGB( 0, 0, 0 ) )
            LineXY( x - 5, y + h + 5, x + 5, y + h - 5, RGB( 0, 0, 0 ) )
            ; ***
            LineXY( x + w - 5, y + h - 5, x + w + 5, y + h + 5, RGB( 0, 0, 0 ) )
            LineXY( x + w - 5, y + h + 5, x + w + 5, y + h - 5, RGB( 0, 0, 0 ) )
            ; ***
            If t
              Box( ww, y + h - #mexsize - #mexsize - TextHeight(t) + 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( ww + 1, y + h - #mexsize - #mexsize - TextHeight(t) + 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( ww + 4, y + h - #mexsize - #mexsize - TextHeight(t) + 4 + 4, t, RGB( 0, 0, 0 ) )
            EndIf
        EndSelect
      EndWith
    EndIf
  EndIf
EndProcedure

Procedure element_mseinheit_4( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  If *obj
    Protected *itm.gui_visual_measure_item_struct = *obj, yy.l, t.s = ""
    ; ***
    If *itm
      With *itm
        DrawingMode( #PB_2DDrawing_Transparent )
        ; ***
        t = Trim(pick(0,";",\label))
        ; ***
        If t
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : t + " mm"
                  Case 2 : t + " cm"
                  Case 3 : t + " dm"
                  Case 4 : t + " m"
                  Case 5 : t + " in"
                  Case 6 : t + " pt"
                  Case 7 : t + " px"
                EndSelect
              EndIf
            Case 1 : t + " mm"
            Case 2 : t + " cm"
            Case 3 : t + " dm"
            Case 4 : t + " m"
            Case 5 : t + " in"
            Case 6 : t + " pt"
            Case 7 : t + " px"
          EndSelect
          ; ***
          yy = y + ( ( h - TextHeight(t) ) / 2 )
        EndIf
        ; ***
        LineXY( x, y + h, x + w, y, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x + w - 5, y - 5, x + w + 5, y + 5, RGB( 0, 0, 0 ) )
        LineXY( x + w - 5, y + 5, x + w + 5, y - 5, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x - 5, y + h - 5, x + 5, y + h + 5, RGB( 0, 0, 0 ) )
        LineXY( x - 5, y + h + 5, x + 5, y + h - 5, RGB( 0, 0, 0 ) )
        ; ***
        Select \etop
          Case 0 To 19
            If t
              Box( x + w - TextWidth(t), y - #mexsize - TextHeight(t) - 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( x + w - TextWidth(t) + 1, y - #mexsize - TextHeight(t) - 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( x + w - TextWidth(t) + 4, y - #mexsize - TextHeight(t), t, RGB( 0, 0, 0 ) )
            EndIf
          Default
            If t
              Box( x - #mexsize, y + h + #mexsize - 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( x - #mexsize + 1, y + h + #mexsize - 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( x - #mexsize + 4, y + h + #mexsize, t, RGB( 0, 0, 0 ) )
            EndIf
        EndSelect
      EndWith
    EndIf
  EndIf
EndProcedure

Procedure element_mseinheit_5( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  If *obj
    Protected *itm.gui_visual_measure_item_struct = *obj, yy.l, t.s = ""
    ; ***
    If *itm
      With *itm
        DrawingMode( #PB_2DDrawing_Transparent )
        ; ***
        t = Trim(pick(0,";",\label))
        ; ***
        If t
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : t + " mm"
                  Case 2 : t + " cm"
                  Case 3 : t + " dm"
                  Case 4 : t + " m"
                  Case 5 : t + " in"
                  Case 6 : t + " pt"
                  Case 7 : t + " px"
                EndSelect
              EndIf
            Case 1 : t + " mm"
            Case 2 : t + " cm"
            Case 3 : t + " dm"
            Case 4 : t + " m"
            Case 5 : t + " in"
            Case 6 : t + " pt"
            Case 7 : t + " px"
          EndSelect
          ; ***
          yy = y + ( ( h - TextHeight(t) ) / 2 )
        EndIf
        ; ***
        LineXY( x, y, x + w, y + h, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x - 5, y - 5, x + 5, y + 5, RGB( 0, 0, 0 ) )
        LineXY( x - 5, y + 5, x + 5, y - 5, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x + w - 5, y + h - 5, x + w + 5, y + h + 5, RGB( 0, 0, 0 ) )
        LineXY( x + w - 5, y + h + 5, x + w + 5, y + h - 5, RGB( 0, 0, 0 ) )
        ; ***
        Select \etop
          Case 0 To 19
            If t
              Box( x - #mexsize, y - #mexsize - TextHeight(t) - 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( x - #mexsize + 1, y - #mexsize - TextHeight(t) - 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( x - #mexsize + 4, y - #mexsize - TextHeight(t), t, RGB( 0, 0, 0 ) )
            EndIf
          Default
            If t
              Box( x + w - TextWidth(t), y + h + #mexsize - 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( x + w - TextWidth(t) + 1, y + h + #mexsize - 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( x + w - TextWidth(t) + 4, y + h + #mexsize, t, RGB( 0, 0, 0 ) )
            EndIf
        EndSelect
      EndWith
    EndIf
  EndIf
EndProcedure

Procedure element_mseinheit_6( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  If *obj
    Protected *itm.gui_visual_measure_item_struct = *obj, yy.l, ww.l, t.s = "", d.s = ""
    ; ***
    If *itm
      With *itm
        DrawingMode( #PB_2DDrawing_Transparent )
        ; ***
        t = Trim(pick(0,";",\label))
        d = Trim(pick(1,";",\label))
        ; ***
        If t
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : t + " mm"
                  Case 2 : t + " cm"
                  Case 3 : t + " dm"
                  Case 4 : t + " m"
                  Case 5 : t + " in"
                  Case 6 : t + " pt"
                  Case 7 : t + " px"
                EndSelect
              EndIf
            Case 1 : t + " mm"
            Case 2 : t + " cm"
            Case 3 : t + " dm"
            Case 4 : t + " m"
            Case 5 : t + " in"
            Case 6 : t + " pt"
            Case 7 : t + " px"
          EndSelect
          ; ***
          yy = y + ( ( h - TextHeight(t) ) / 2 )
        EndIf
        ; ***
        If d
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : d + " mm"
                  Case 2 : d + " cm"
                  Case 3 : d + " dm"
                  Case 4 : d + " m"
                  Case 5 : d + " in"
                  Case 6 : d + " pt"
                  Case 7 : d + " px"
                EndSelect
              EndIf
            Case 1 : d + " mm"
            Case 2 : d + " cm"
            Case 3 : d + " dm"
            Case 4 : d + " m"
            Case 5 : d + " in"
            Case 6 : d + " pt"
            Case 7 : d + " px"
          EndSelect
          ; ***
          ww = x + ( ( w - TextWidth(d) ) / 2 )
        EndIf
        ; ***
        Box( x, y, 1, h, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x - 5, y - 5, x + 5, y + 5, RGB( 0, 0, 0 ) )
        LineXY( x - 5, y + 5, x + 5, y - 5, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x - 5, y + h - 5, x + 5, y + h + 5, RGB( 0, 0, 0 ) )
        LineXY( x - 5, y + h + 5, x + 5, y + h - 5, RGB( 0, 0, 0 ) )
        ; ***
        Box( x, y, w, 1, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x - 5, y - 5, x + 5, y + 5, RGB( 0, 0, 0 ) )
        LineXY( x - 5, y + 5, x + 5, y - 5, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x + w - 5, y - 5, x + w + 5, y + 5, RGB( 0, 0, 0 ) )
        LineXY( x + w - 5, y + 5, x + w + 5, y - 5, RGB( 0, 0, 0 ) )
        ; ***
        Select \etop
          Case 0 To 19
            If t
              Box( x - #mexsize - #mexsize - TextWidth(t) + 4, yy - 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( x - #mexsize - #mexsize - TextWidth(t) + 4 + 1, yy - 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( x - #mexsize - #mexsize - TextWidth(t) + 4 + 4, yy, t, RGB( 0, 0, 0 ) )
            EndIf
            ; ***
            If d
              Box( ww, y - #mexsize - #mexsize - TextHeight(d) + 4, TextWidth(d) + 8, TextHeight(d) + 8, RGB( 0, 0, 0 ) )
              Box( ww + 1, y - #mexsize - #mexsize - TextHeight(d) + 4 + 1, TextWidth(d) + 8 - 2, TextHeight(d) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( ww + 4, y - #mexsize - #mexsize - TextHeight(d) + 4 + 4, d, RGB( 0, 0, 0 ) )
            EndIf
          Default
            If t
              Box( x + #mexsize, yy - 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( x + #mexsize + 1, yy - 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( x + #mexsize + 4, yy, t, RGB( 0, 0, 0 ) )
            EndIf
            ; ***
            If d
              Box( ww, y + #mexsize, TextWidth(d) + 8, TextHeight(d) + 8, RGB( 0, 0, 0 ) )
              Box( ww + 1, y + #mexsize + 1, TextWidth(d) + 8 - 2, TextHeight(d) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( ww + 4, y + #mexsize + 4, d, RGB( 0, 0, 0 ) )
            EndIf
        EndSelect
      EndWith
    EndIf
  EndIf
EndProcedure

Procedure element_mseinheit_7( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  If *obj
    Protected *itm.gui_visual_measure_item_struct = *obj, yy.l, ww.l, t.s = "", d.s = ""
    ; ***
    If *itm
      With *itm
        DrawingMode( #PB_2DDrawing_Transparent )
        ; ***
        t = Trim(pick(0,";",\label))
        d = Trim(pick(1,";",\label))
        ; ***
        If t
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : t + " mm"
                  Case 2 : t + " cm"
                  Case 3 : t + " dm"
                  Case 4 : t + " m"
                  Case 5 : t + " in"
                  Case 6 : t + " pt"
                  Case 7 : t + " px"
                EndSelect
              EndIf
            Case 1 : t + " mm"
            Case 2 : t + " cm"
            Case 3 : t + " dm"
            Case 4 : t + " m"
            Case 5 : t + " in"
            Case 6 : t + " pt"
            Case 7 : t + " px"
          EndSelect
          ; ***
          yy = y + ( ( h - TextHeight(t) ) / 2 )
        EndIf
        ; ***
        If d
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : d + " mm"
                  Case 2 : d + " cm"
                  Case 3 : d + " dm"
                  Case 4 : d + " m"
                  Case 5 : d + " in"
                  Case 6 : d + " pt"
                  Case 7 : d + " px"
                EndSelect
              EndIf
            Case 1 : d + " mm"
            Case 2 : d + " cm"
            Case 3 : d + " dm"
            Case 4 : d + " m"
            Case 5 : d + " in"
            Case 6 : d + " pt"
            Case 7 : d + " px"
          EndSelect
          ; ***
          ww = x + ( ( w - TextWidth(d) ) / 2 )
        EndIf
        ; ***
        Box( x + w, y, 1, h, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x + w - 5, y - 5, x + w + 5, y + 5, RGB( 0, 0, 0 ) )
        LineXY( x + w  - 5, y + 5, x + w + 5, y - 5, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x + w  - 5, y + h - 5, x + w + 5, y + h + 5, RGB( 0, 0, 0 ) )
        LineXY( x + w  - 5, y + h + 5, x + w + 5, y + h - 5, RGB( 0, 0, 0 ) )
        ; ***
        Box( x + 2, y, w, 1, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x - 5, y - 5, x + 5, y + 5, RGB( 0, 0, 0 ) )
        LineXY( x - 5, y + 5, x + 5, y - 5, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x + w - 5, y - 5, x + w + 5, y + 5, RGB( 0, 0, 0 ) )
        LineXY( x + w - 5, y + 5, x + w + 5, y - 5, RGB( 0, 0, 0 ) )
        ; ***
        Select \etop
          Case 0 To 19
            If t
              Box( x + w + #mexsize - 4, yy - 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( x + w + #mexsize - 4 + 1, yy - 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( x + w + #mexsize - 4 + 4, yy, t, RGB( 0, 0, 0 ) )
            EndIf
            ; ***
            If d
              Box( ww, y - #mexsize - #mexsize - TextHeight(d) + 4, TextWidth(d) + 8, TextHeight(d) + 8, RGB( 0, 0, 0 ) )
              Box( ww + 1, y - #mexsize - #mexsize - TextHeight(d) + 4 + 1, TextWidth(d) + 8 - 2, TextHeight(d) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( ww + 4, y - #mexsize - #mexsize - TextHeight(d) + 4 + 4, d, RGB( 0, 0, 0 ) )
            EndIf
          Default
            If t
              Box( x + w - #mexsize - #mexsize - TextWidth(t) + 6, yy - 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( x + w - #mexsize - #mexsize - TextWidth(t) + 6 + 1, yy - 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( x + w - #mexsize - #mexsize - TextWidth(t) + 6 + 4, yy, t, RGB( 0, 0, 0 ) )
            EndIf
            ; ***
            If d
              Box( ww, y + #mexsize, TextWidth(d) + 8, TextHeight(d) + 8, RGB( 0, 0, 0 ) )
              Box( ww + 1, y + #mexsize + 1, TextWidth(d) + 8 - 2, TextHeight(d) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( ww + 4, y + #mexsize + 4, d, RGB( 0, 0, 0 ) )
            EndIf
        EndSelect
      EndWith
    EndIf
  EndIf
EndProcedure

Procedure element_mseinheit_8( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  If *obj
    Protected *itm.gui_visual_measure_item_struct = *obj, yy.l, ww.l, t.s = "", d.s = ""
    ; ***
    If *itm
      With *itm
        DrawingMode( #PB_2DDrawing_Transparent )
        ; ***
        t = Trim(pick(0,";",\label))
        d = Trim(pick(1,";",\label))
        ; ***
        If t
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : t + " mm"
                  Case 2 : t + " cm"
                  Case 3 : t + " dm"
                  Case 4 : t + " m"
                  Case 5 : t + " in"
                  Case 6 : t + " pt"
                  Case 7 : t + " px"
                EndSelect
              EndIf
            Case 1 : t + " mm"
            Case 2 : t + " cm"
            Case 3 : t + " dm"
            Case 4 : t + " m"
            Case 5 : t + " in"
            Case 6 : t + " pt"
            Case 7 : t + " px"
          EndSelect
          ; ***
          yy = y + ( ( h - TextHeight(t) ) / 2 )
        EndIf
        ; ***
        If d
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : d + " mm"
                  Case 2 : d + " cm"
                  Case 3 : d + " dm"
                  Case 4 : d + " m"
                  Case 5 : d + " in"
                  Case 6 : d + " pt"
                  Case 7 : d + " px"
                EndSelect
              EndIf
            Case 1 : d + " mm"
            Case 2 : d + " cm"
            Case 3 : d + " dm"
            Case 4 : d + " m"
            Case 5 : d + " in"
            Case 6 : d + " pt"
            Case 7 : d + " px"
          EndSelect
          ; ***
          ww = x + ( ( w - TextWidth(d) ) / 2 )
        EndIf
        ; ***
        Box( x, y, 1, h, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x - 5, y - 5, x + 5, y + 5, RGB( 0, 0, 0 ) )
        LineXY( x - 5, y + 5, x + 5, y - 5, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x - 5, y + h - 5, x + 5, y + h + 5, RGB( 0, 0, 0 ) )
        LineXY( x - 5, y + h + 5, x + 5, y + h - 5, RGB( 0, 0, 0 ) )
        ; ***
        Box( x, y + h, w, 1, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x - 5, y + h - 5, x + 5, y + h + 5, RGB( 0, 0, 0 ) )
        LineXY( x - 5, y + h + 5, x + 5, y + h - 5, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x + w - 5, y + h - 5, x + w + 5, y + h + 5, RGB( 0, 0, 0 ) )
        LineXY( x + w - 5, y + h + 5, x + w + 5, y + h - 5, RGB( 0, 0, 0 ) )
        ; ***
        Select \etop
          Case 0 To 19
            If t
              Box( x - #mexsize - #mexsize - TextWidth(t) + 4, yy - 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( x - #mexsize - #mexsize - TextWidth(t) + 4 + 1, yy - 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( x - #mexsize - #mexsize - TextWidth(t) + 4 + 4, yy, t, RGB( 0, 0, 0 ) )
            EndIf
            ; ***
            If d
              Box( ww, y + h + #mexsize, TextWidth(d) + 8, TextHeight(d) + 8, RGB( 0, 0, 0 ) )
              Box( ww + 1, y + h + #mexsize + 1, TextWidth(d) + 8 - 2, TextHeight(d) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( ww + 4, y + h + #mexsize + 4, d, RGB( 0, 0, 0 ) )
            EndIf
          Default
            If t
              Box( x + #mexsize, yy - 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( x + #mexsize + 1, yy - 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( x + #mexsize + 4, yy, t, RGB( 0, 0, 0 ) )
            EndIf
            ; ***
            If d
              Box( ww, y + h - #mexsize - #mexsize - TextHeight(d) + 4, TextWidth(d) + 8, TextHeight(d) + 8, RGB( 0, 0, 0 ) )
              Box( ww + 1, y + h - #mexsize - #mexsize - TextHeight(d) + 4 + 1, TextWidth(d) + 8 - 2, TextHeight(d) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( ww + 4, y + h - #mexsize - #mexsize - TextHeight(d) + 4 + 4, d, RGB( 0, 0, 0 ) )
            EndIf
        EndSelect
      EndWith
    EndIf
  EndIf
EndProcedure

Procedure element_mseinheit_9( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  If *obj
    Protected *itm.gui_visual_measure_item_struct = *obj, yy.l, ww.l, t.s = "", d.s = ""
    ; ***
    If *itm
      With *itm
        DrawingMode( #PB_2DDrawing_Transparent )
        ; ***
        t = Trim(pick(0,";",\label))
        d = Trim(pick(1,";",\label))
        ; ***
        If t
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : t + " mm"
                  Case 2 : t + " cm"
                  Case 3 : t + " dm"
                  Case 4 : t + " m"
                  Case 5 : t + " in"
                  Case 6 : t + " pt"
                  Case 7 : t + " px"
                EndSelect
              EndIf
            Case 1 : t + " mm"
            Case 2 : t + " cm"
            Case 3 : t + " dm"
            Case 4 : t + " m"
            Case 5 : t + " in"
            Case 6 : t + " pt"
            Case 7 : t + " px"
          EndSelect
          ; ***
          yy = y + ( ( h - TextHeight(t) ) / 2 )
        EndIf
        ; ***
        If d
          Select \measure
            Case 0
              If *gui_virtual_measure_render_active_field
                Select *gui_virtual_measure_render_active_field\measurevalue - 1
                  Case 1 : d + " mm"
                  Case 2 : d + " cm"
                  Case 3 : d + " dm"
                  Case 4 : d + " m"
                  Case 5 : d + " in"
                  Case 6 : d + " pt"
                  Case 7 : d + " px"
                EndSelect
              EndIf
            Case 1 : d + " mm"
            Case 2 : d + " cm"
            Case 3 : d + " dm"
            Case 4 : d + " m"
            Case 5 : d + " in"
            Case 6 : d + " pt"
            Case 7 : d + " px"
          EndSelect
          ; ***
          ww = x + ( ( w - TextWidth(d) ) / 2 )
        EndIf
        ; ***
        Box( x + w, y, 1, h, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x + w - 5, y - 5, x + w + 5, y + 5, RGB( 0, 0, 0 ) )
        LineXY( x + w - 5, y + 5, x + w + 5, y - 5, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x + w - 5, y + h - 5, x + w + 5, y + h + 5, RGB( 0, 0, 0 ) )
        LineXY( x + w - 5, y + h + 5, x + w + 5, y + h - 5, RGB( 0, 0, 0 ) )
        ; ***
        Box( x, y + h, w, 1, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x - 5, y + h - 5, x + 5, y + h + 5, RGB( 0, 0, 0 ) )
        LineXY( x - 5, y + h + 5, x + 5, y + h - 5, RGB( 0, 0, 0 ) )
        ; ***
        LineXY( x + w - 5, y + h - 5, x + w + 5, y + h + 5, RGB( 0, 0, 0 ) )
        LineXY( x + w - 5, y + h + 5, x + w + 5, y + h - 5, RGB( 0, 0, 0 ) )
        ; ***
        Select \etop
          Case 0 To 19
            If t
              Box( x + w + #mexsize - 4, yy - 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( x + w + #mexsize - 4 + 1, yy - 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( x + w + #mexsize - 4 + 4, yy, t, RGB( 0, 0, 0 ) )
            EndIf
            ; ***
            If d
              Box( ww, y + h + #mexsize, TextWidth(d) + 8, TextHeight(d) + 8, RGB( 0, 0, 0 ) )
              Box( ww + 1, y + h + #mexsize + 1, TextWidth(d) + 8 - 2, TextHeight(d) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( ww + 4, y + h + #mexsize + 4, d, RGB( 0, 0, 0 ) )
            EndIf
          Default
            If t
              Box( x + w - #mexsize - #mexsize - TextWidth(t) + 6, yy - 4, TextWidth(t) + 8, TextHeight(t) + 8, RGB( 0, 0, 0 ) )
              Box( x + w - #mexsize - #mexsize - TextWidth(t) + 6 + 1, yy - 4 + 1, TextWidth(t) + 8 - 2, TextHeight(t) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( x + w - #mexsize - #mexsize - TextWidth(t) + 6 + 4, yy, t, RGB( 0, 0, 0 ) )
            EndIf
            ; ***
            If d
              Box( ww, y + h - #mexsize - #mexsize - TextHeight(d) + 4, TextWidth(d) + 8, TextHeight(d) + 8, RGB( 0, 0, 0 ) )
              Box( ww + 1, y + h - #mexsize - #mexsize - TextHeight(d) + 4 + 1, TextWidth(d) + 8 - 2, TextHeight(d) + 8 - 2, RGB( 255, 255, 255 ) )
              ; ***
              DrawText( ww + 4, y + h - #mexsize - #mexsize - TextHeight(d) + 4 + 4, d, RGB( 0, 0, 0 ) )
            EndIf
        EndSelect
      EndWith
    EndIf
  EndIf
EndProcedure

CompilerIf #PB_Compiler_IsMainFile = 1

Procedure rechteck1( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Box( x, y, w, h, RGB( 200, 60, 70 ) )
  Box( x + 1, y + 1, w - 2, h - 2, RGB( 200, 60, 70 ) )
  Box( x + 2, y + 2, w - 4, h - 4, RGB( 200, 60, 70 ) )
  Box( x + 3, y + 3, w - 6, h - 6, RGB( 200, 60, 70 ) )
EndProcedure

Procedure rechteck2( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  Protected e.a, *elm.gui_visual_measure_item_struct = *obj
  e = 0;8
  *elm\etop = e
  *elm\eleft = e
  *elm\eright = e
  *elm\ebottom = e
  element_door_15( pic, x, y, w, h, text, *obj )
;  GrabImage( _guivmr_2, _guivmr_3, 0, 0, ImageWidth(_guivmr_2) / 2, ImageHeight(_guivmr_2) )
;  ; ***
;  If IsImage( _guivmr_3 )
;    ResizeImage( _guivmr_3, w, h )
;    ; ***
;    DrawAlphaImage( ImageID( _guivmr_3 ), x, y )
;  EndIf
EndProcedure

Procedure rechteck3( pic.u, x.w, y.w, w.w, h.w, text.s, *obj )
  DrawingMode( #PB_2DDrawing_Outlined )
  ; ***
  Box( x, y, w, h, RGB( 70, 60, 200 ) )
  Box( x + 1, y + 1, w - 2, h - 2, RGB( 70, 60, 200 ) )
  Box( x + 2, y + 2, w - 4, h - 4, RGB( 70, 60, 200 ) )
  Box( x + 3, y + 3, w - 6, h - 6, RGB( 70, 60, 200 ) )
EndProcedure

Global gvmo.gui_visual_measure_object_struct ; Verwaltet alle Render zu einem Objekt
Global gvmr.gui_visual_measure_render_struct ; Bearbeitet einen Render

OpenWindow( 10, 0, 0, 1000, 640, "Visual Measure Render", #PB_Window_SystemMenu|#PB_Window_ScreenCentered )
CanvasGadget( 20, 0, 0, 900, 640 )
ButtonGadget( 30, 910, 10, 80, 30, "Item 1" )
ButtonGadget( 31, 910, 50, 80, 30, "Item 2" )
ButtonGadget( 32, 910, 90, 80, 30, "Item 3" )

OptionGadget( 33, 910, 150, 80, 30, "Default" )
OptionGadget( 34, 910, 180, 80, 30, "No Mark" )
OptionGadget( 35, 910, 210, 80, 30, "No Mark+" )
OptionGadget( 36, 910, 240, 80, 30, "No Mark++" )
SetGadgetState( 33, 1 )

With gvmr
  \viewmode = 0
  \measure = "cm"
  \id = 20
  \img_back = 10
  \img_rest = 11
  \img_sele = 12
  \img_temp = 13
  \img_this = 14
  \color_back = RGB(255, 255, 255)
  \color_grid = RGB(160, 160, 160)
  \color_text = RGB(0, 0, 0)
  \color_selb = RGB( 50, 80, 160 )
  \color_selm = RGB( 50, 80, 120 )
  \fid = 100 : LoadFont( 100, "Arial", 8 )
  \pixw = #mexsize
  \pixh = #mexsize
  \flag_back = 0
  \flag_rest = 0
  \flag_sele = 0
EndWith

add_visual_measure_render_item( gvmr, 1, "Küche", @rechteck2() )
draw_visual_measure_render( gvmr )

Repeat
  e.i = WaitWindowEvent(50)
  ; ***
  Select e
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 20 ; Canvas
          event_visual_measure_render( gvmr, e )
        Case 30 ; Item 1
          add_visual_measure_render_item( gvmr, 1, InputRequester("Wie heißt das Element?","Bezeichner","??"), @rechteck1() )
        Case 31 ; Item 2
          add_visual_measure_render_item( gvmr, 2, InputRequester("Wie heißt das Element?","Bezeichner","??"), @rechteck2() )
        Case 32 ; Item 3
          add_visual_measure_render_item( gvmr, 3, InputRequester("Wie heißt das Element?","Bezeichner","??"), @rechteck3() )
        Case 33, 34, 35,36 ; Default, No Mark, No Mark+, No Mark++
          Select EventGadget()
            Case 33 : gvmr\viewmode = 0 : draw_visual_measure_render( gvmr )
            Case 34 : gvmr\viewmode = 1 : draw_visual_measure_render( gvmr )
            Case 35 : gvmr\viewmode = 2 : draw_visual_measure_render( gvmr )
            Case 36 : gvmr\viewmode = 3 : draw_visual_measure_render( gvmr )
          EndSelect
      EndSelect
  EndSelect
Until e = #PB_Event_CloseWindow

End

CompilerEndIf

;

; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 5654
; FirstLine = 579
; Folding = AAAA5BAAAAAAAAAAAAAAAAAQAAAAAI+
; EnableXP