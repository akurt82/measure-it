XIncludeFile "gui_visual_measure_render.pbi"

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  #sysChar = "\"
CompilerElse
  #sysChar = "/"
CompilerEndIf

Global appPath.s = "", prePath.s = "", datPath.s = ""

appPath = GetPathPart(ProgramFilename())

If Right( appPath, 1 ) <> #sysChar
  appPath + #sysChar
EndIf

CompilerSelect #PB_Compiler_OS
  CompilerCase #PB_OS_MacOS
    prePath = appPath + "settings"
  CompilerCase #PB_OS_Linux
    prePath = appPath + "settings"
  CompilerCase #PB_OS_Windows
    prePath = appPath + "settings"
CompilerEndSelect

datPath = appPath + "objects"

If FileSize(prePath) <> -2
  CreateDirectory(prePath)
EndIf

If FileSize(datPath) <> -2
  CreateDirectory(datPath)
EndIf

prePath + #sysChar

UsePNGImageDecoder()

Enumeration
  #fenster1 = 10
  #fenster2
  #fenster3
  #fenster4
  #fenster5
  #fenster6
  #fenster7
  #fenster8
  #fenster9
  #fenster10
  #fenster11
  #fenster12
  #fenster13
  ; ***
  #panelmn
  #panelsd
  #panelb1
  #panelb2
  #panelb3
  #panelb4
  #panelb5
  #panelb6
  #panelb7
  #panelb8
  #panelb9
  #panelb10
  #canvas1
  #canvas2
  #canvas3
  #canvas4
  ; ***
  #login_label_1
  #login_label_2
  #login_input_1
  #login_input_2
  #login_button_1
  #login_button_2
  ; ***
  #label_input
  #label_ok
  #label_cancel
  ; ***
  #label_object_name
  #label_object_text
  ; ***
  #label_button_1
  #label_button_2
  #label_button_3
  #label_button_4
  ; ***
  #radio_1
  #radio_2
  #radio_3
  #radio_4
  ; ***
  #zoom_label
  #zoom_track
  ; ***
  #combo_shape_selector
  #entry_shape
  ; ***
  #hk_enter = 1000
  #hk_escape
EndEnumeration

Global Dim image_a.u(210)

Global _ptrix.w = 0

For _ptrix = 1001 To 1209
  image_a(_ptrix - 1001) = _ptrix
Next

getIMG( 950, "icons/ico_new_object.png", _a_0_ )
getIMG( 951, "icons/ico_switch_object.png", _a_1_ )
getIMG( 952, "icons/ico_delete_object.png", _a_2_ )
getIMG( 953, "icons/ico_open.png", _a_3_ )
getIMG( 954, "icons/ico_save.png", _a_4_ )
getIMG( 955, "icons/ico_add.png", _a_5_ )
getIMG( 956, "icons/ico_delete.png", _a_6_ )
getIMG( 957, "icons/ico_edit.png", _a_7_ )
getIMG( 958, "icons/ico_send.png", _a_8_ )
getIMG( 959, "icons/ico_conf.png", _a_9_ )
getIMG( 960, "icons/ico_delete_draft.png", _a_10_ )
getIMG( 961, "icons/ico_export.png", _a_10_0_ )

getIMG( image_a(0), "icons/rechteck.png", _a_11_ )
getIMG( image_a(1), "icons/ellipse.png", _a_12_ )
getIMG( image_a(2), "icons/kreis.png", _a_13_ )
getIMG( image_a(3), "icons/rechteck_gekippt.png", _a_14_ )
getIMG( image_a(4), "icons/sechseck_a.png", _a_15_ )
getIMG( image_a(5), "icons/sechseck_b.png", _a_16_ )
getIMG( image_a(6), "icons/voll_dreieck_a.png", _a_17_ )
getIMG( image_a(7), "icons/voll_dreieck_b.png", _a_18_ )
getIMG( image_a(8), "icons/voll_dreieck_c.png", _a_19_ )
getIMG( image_a(9), "icons/voll_dreieck_d.png", _a_20_ )
getIMG( image_a(10), "icons/teil_dreieck_a.png", _a_21_ )
getIMG( image_a(11), "icons/teil_dreieck_b.png", _a_22_ )
getIMG( image_a(12), "icons/teil_dreieck_c.png", _a_23_ )
getIMG( image_a(13), "icons/teil_dreieck_d.png", _a_24_ )
getIMG( image_a(14), "icons/alt_dreieck_b.png", _a_25_ )
getIMG( image_a(15), "icons/alt_dreieck_c.png", _a_26_ )
getIMG( image_a(16), "icons/alt_dreieck_d.png", _a_27_ )
getIMG( image_a(17), "icons/alt_dreieck_a.png", _a_28_ )
getIMG( image_a(18), "icons/halb_raute_a.png", _a_29_ )
getIMG( image_a(19), "icons/halb_raute_b.png", _a_30_ )
getIMG( image_a(20), "icons/halb_raute_c.png", _a_31_ )
getIMG( image_a(21), "icons/halb_raute_d.png", _a_32_ )

getIMG( image_a(22), "icons/text_input.png", _a_33_ )
getIMG( image_a(23), "icons/numbering_1.png", _a_33a_ )
getIMG( image_a(24), "icons/numbering_2.png", _a_33b_ )
getIMG( image_a(25), "icons/pfeil_1.png", _a_34_ )
getIMG( image_a(26), "icons/pfeil_2.png", _a_35_ )
getIMG( image_a(27), "icons/pfeil_3.png", _a_36_ )
getIMG( image_a(91), "icons/pfeil_4.png", _a_37_ )

getIMG( image_a(28), "icons/treppe_1.png", _b_0_ )
getIMG( image_a(29), "icons/treppe_2.png", _b_1_ )
getIMG( image_a(30), "icons/treppe_3.png", _b_2_ )
getIMG( image_a(31), "icons/treppe_4.png", _b_3_ )
getIMG( image_a(32), "icons/treppe_5.png", _b_4_ )
getIMG( image_a(33), "icons/treppe_6.png", _b_5_ )
getIMG( image_a(34), "icons/treppe_7.png", _b_6_ )
getIMG( image_a(35), "icons/treppe_8.png", _b_7_ )
getIMG( image_a(36), "icons/treppe_9.png", _b_8_ )
getIMG( image_a(37), "icons/treppe_10.png", _b_9_ )
getIMG( image_a(38), "icons/treppe_11.png", _b_10_ )
getIMG( image_a(39), "icons/treppe_12.png", _b_11_ )
getIMG( image_a(40), "icons/treppe_13.png", _b_12_ )
getIMG( image_a(41), "icons/treppe_14.png", _b_13_ )
getIMG( image_a(42), "icons/treppe_15.png", _b_14_ )
getIMG( image_a(43), "icons/treppe_16.png", _b_15_ )
getIMG( image_a(44), "icons/treppe_17.png", _b_16_ )
getIMG( image_a(45), "icons/treppe_18.png", _b_17_ )
getIMG( image_a(46), "icons/treppe_19.png", _b_18_ )
getIMG( image_a(47), "icons/treppe_20.png", _b_19_ )
getIMG( image_a(48), "icons/treppe_21.png", _b_20_ )
getIMG( image_a(49), "icons/treppe_22.png", _b_21_ )
getIMG( image_a(50), "icons/treppe_23.png", _b_22_ )
getIMG( image_a(51), "icons/treppe_24.png", _b_23_ )
getIMG( image_a(52), "icons/treppe_25.png", _b_24_ )
getIMG( image_a(53), "icons/treppe_26.png", _b_25_ )
getIMG( image_a(54), "icons/treppe_27.png", _b_26_ )
getIMG( image_a(55), "icons/treppe_28.png", _b_27_ )
getIMG( image_a(56), "icons/treppe_29.png", _b_28_ )
getIMG( image_a(57), "icons/treppe_30.png", _b_29_ )
getIMG( image_a(58), "icons/treppe_31.png", _b_30_ )
getIMG( image_a(59), "icons/treppe_32.png", _b_31_ )
getIMG( image_a(60), "icons/treppe_33.png", _b_32_ )
getIMG( image_a(61), "icons/treppe_34.png", _b_33_ )
getIMG( image_a(62), "icons/treppe_35.png", _b_34_ )
getIMG( image_a(63), "icons/treppe_36.png", _b_35_ )
getIMG( image_a(64), "icons/treppe_37.png", _b_36_ )
getIMG( image_a(65), "icons/treppe_38.png", _b_37_ )
getIMG( image_a(66), "icons/treppe_39.png", _b_38_ )
getIMG( image_a(67), "icons/treppe_40.png", _b_39_ )
getIMG( image_a(68), "icons/treppe_41.png", _b_40_ )
getIMG( image_a(69), "icons/treppe_42.png", _b_41_ )
getIMG( image_a(70), "icons/treppe_43.png", _b_42_ )
getIMG( image_a(71), "icons/treppe_44.png", _b_43_ )
getIMG( image_a(72), "icons/treppe_45.png", _b_44_ )
getIMG( image_a(73), "icons/treppe_46.png", _b_45_ )
getIMG( image_a(74), "icons/treppe_47.png", _b_46_ )
getIMG( image_a(75), "icons/treppe_48.png", _b_47_ )

getIMG( image_a(76), "icons/fenster_1.png", _b_48_ )
getIMG( image_a(77), "icons/fenster_2.png", _b_49_ )

getIMG( image_a(78), "icons/door_1.png", _b_50_ )
getIMG( image_a(79), "icons/door_2.png", _b_51_ )
getIMG( image_a(80), "icons/door_3.png", _b_52_ )
getIMG( image_a(81), "icons/door_4.png", _b_53_ )
getIMG( image_a(82), "icons/door_5.png", _b_54_ )
getIMG( image_a(83), "icons/door_6.png", _b_55_ )
getIMG( image_a(84), "icons/door_7.png", _b_56_ )
getIMG( image_a(85), "icons/door_8.png", _b_57_ )
getIMG( image_a(86), "icons/door_9.png", _b_58_ )
getIMG( image_a(87), "icons/door_10.png", _b_59_ )
getIMG( image_a(88), "icons/door_11.png", _b_60_ )
getIMG( image_a(89), "icons/door_12.png", _b_61_ )

getIMG( image_a(90), "icons/fenster_doppelt.png", _b_62_ )

getIMG( image_a(92), "icons/aufzug_1.png", _b_63_ )
getIMG( image_a(93), "icons/aufzug_2.png", _b_64_ )
getIMG( image_a(94), "icons/aufzug_3.png", _b_65_ )
getIMG( image_a(95), "icons/aufzug_4.png", _b_66_ )

getIMG( image_a(96), "icons/stuetze_1.png", _b_67_ )
getIMG( image_a(97), "icons/stuetze_2.png", _b_68_ )

getIMG( image_a(98), "icons/kamin.png", _b_69_ )

getIMG( image_a(99), "icons/pixel_exact.png", _b_70_ )

getIMG( image_a(100), "icons/__dach_schraege_h.png", _b_71_ )
getIMG( image_a(101), "icons/__dach_schraege_v.png", _b_72_ )

Prototype dlgmain_bar_callback( key.s )

Declare menu_dlgMain( key.s )
Declare show_dlgLogin()
Declare show_dlgMain()

Global loopE.i

Global draft_item.w = 0

Global window_counter.w = 0

Global setup_lang.a = 0, setup_meas.a = 0, setup_digi.a = 0
Global setup_path.s = "", setup_user.s = "", setup_pass.s = ""

Global current_element_type.a = 0

Global gvmo.gui_visual_measure_object_struct ; Verwaltet alle Render zu einem Objekt
Global gvmr.gui_visual_measure_render_struct ; Bearbeitet einen Render

Structure objectlist_struct
  object.s : address.s : pcode.s : town.s
EndStructure

Global NewList objectlist.objectlist_struct()
Global current_objectitem.w = 0

Global _cur_etop.a, _cur_ebottom.a, _cur_eleft.a, _cur_eright.a

LoadFont( 800, "Arial", 14 )

; Element Popup
If CreatePopupMenu( 901 )
  MenuItem( 2021, "Ausschneiden" )
  MenuItem( 2022, "Kopieren" )
  MenuBar()
  MenuItem( 2023, "Element duplizieren" )
  MenuBar()
  MenuItem( 2024, "Berbeiten" )
  MenuBar()
  MenuItem( 2025, "Element sperren / entsperren" )
  MenuBar()
  MenuItem( 2026, "Entfernen" )
EndIf

; Entwurf Popup : Auf der Fläche RechtsKlick
If CreatePopupMenu( 902 )
  MenuItem( 2027, "Einfügen" )
  MenuBar()
  MenuItem( 2028, "Entwurf duplizieren" )
  MenuBar()
  MenuItem( 2029, "Entwurf löschen" )
EndIf

; Entwurf Popup : Auf der Entwurfsliste RechtsKlick
If CreatePopupMenu( 903 )
  MenuItem( 2028, "Entwurf duplizieren" )
  MenuBar()
  MenuItem( 2029, "Entwurf löschen" )
EndIf

Global fenster_element_typ.a = 0, element_w.f, element_h.f

; Popup -> Element -> Fenster -> Einfügen -> Vertikal
If CreatePopupMenu( 904 )
  MenuItem( 2101, "Fenster -> Klein -> 0,3m x 0,5m" )
  MenuItem( 2102, "Fenster -> Mittel -> 0,3m x 1,0m" )
  MenuItem( 2103, "Fenster -> Groß -> 0,3m x 2,0m" )
EndIf

; Popup -> Element -> Fenster -> Einfügen -> Horizontal
If CreatePopupMenu( 905 )
  MenuItem( 2104, "Fenster -> Klein -> 0,5m x 0,3m" )
  MenuItem( 2105, "Fenster -> Mittel -> 1,0m x 0,3m" )
  MenuItem( 2106, "Fenster -> Groß -> 2,0m x 0,3m" )
EndIf

; Popup -> Element -> Fenster -> Einfügen -> Beide
If CreatePopupMenu( 906 )
  MenuItem( 2101, "Fenster -> Klein -> 0,3m x 0,5m" )
  MenuItem( 2102, "Fenster -> Mittel -> 0,3m x 1,0m" )
  MenuItem( 2103, "Fenster -> Groß -> 0,3m x 2,0m" )
  MenuBar()
  MenuItem( 2104, "Fenster -> Klein -> 0,5m x 0,3m" )
  MenuItem( 2105, "Fenster -> Mittel -> 1,0m x 0,3m" )
  MenuItem( 2106, "Fenster -> Groß -> 2,0m x 0,3m" )
EndIf

Procedure entwurf_element_rklick( *element.gui_visual_measure_item_struct )
  ProcedureReturn
  If IsMenu(901) And IsWindow(#fenster2)
    DisplayPopupMenu(901, WindowID(#fenster2) )
  EndIf
EndProcedure

Procedure entwurf_flaeche_rklick()
  ProcedureReturn
  If IsMenu(902) And IsWindow(#fenster2)
    DisplayPopupMenu(902, WindowID(#fenster2) )
  EndIf
EndProcedure

With gvmr
  \cb_item = @entwurf_element_rklick()
  \cb_area = @entwurf_flaeche_rklick()
EndWith

Procedure ___loadIn()
  Protected p.w, pth.s
  Protected t.s = "", m.a = 0, ll.s, rr.s
  Protected a.s, b.s, c.s, d.s, e.l = 0, g.s, h.s, j.s = ""
  Protected __a.s, __b.s, __c.s, __d.s
  ; ***
  ClearGadgetItems(#canvas4)
  ; ***
  If ReadFile( 10, gvmo\path, #PB_UTF8 )
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
          Case "{element}" : m = 4
          Default
            Select m
              Case 1, 3, 4
                ll = Trim(pick( 0, "=", t ))
                rr = Trim(pick( 1, "=", t ))
              Case 2
                j + t + #CRLF$
            EndSelect
            ; ***
            Select m
              Case 1
                Select ll
                  Case "customer" : a = rr
                  Case "address" : b = rr
                  Case "postalcode" : c = rr
                  Case "town" : d = rr
                  Case "order" : g = rr
                  Case "deadline" : h = rr
                EndSelect
              Case 3
                Select ll
                  Case "floor" : __a = rr
                  Case "sepunit" : __b = rr
                  Case "unit" : __c = rr
                  Case "sepmode" : __d = rr
                    Select Val(__d)
                      Case 0 : __d = ""
                      Case 1 : __d = "Ja"
                      Case 2 : __d = "Nein"
                      Case 3 : __d = ""
                    EndSelect
                    ; ***
                    add_new_object_unit( gvmo, __a, Val(__b), __c, Val(__d) )
                    ; ***
                    AddGadgetItem( #canvas4, -1, "[" + Str(CountGadgetItems(#canvas4) + 1) + "] " + __a + Chr(10) + __c + Chr(10) + __d )
                    ; ***
                    __a = ""
                    __b = ""
                    __c = ""
                    __d = ""
                EndSelect
            EndSelect
        EndSelect
      EndIf
    Wend
    ; ***
    CloseFile(10)
  EndIf
  ; ***
  gvmo\object = a
  gvmo\address = b
  gvmo\postalcode = c
  gvmo\town = d
  gvmo\order = g
  gvmo\deadline = h
  gvmo\notice = j
  ; ***
  StatusBarText( 20, 0, gvmo\order )
  StatusBarText( 20, 1, gvmo\address )
  StatusBarText( 20, 2, gvmo\postalcode )
  StatusBarText( 20, 3, gvmo\town )
  StatusBarText( 20, 4, "<Kein Entwurf>" )
EndProcedure

Procedure export_jpeg( op1.u, op2.u, op3.u )
  Protected ok.a = 1
  ; ***
  If CreateImage( 1509, GadgetWidth(gvmr\id), GadgetHeight(gvmr\id) ) And 
     StartDrawing( ImageOutput( 1509 ) )
    DrawImage( GetGadgetAttribute(gvmr\id,#PB_Canvas_Image), 0, 0 )
    ; ***
    StopDrawing()
  EndIf
  ; ***
  GrabImage( 1509, 1510, gvmr\edgex1, gvmr\edgey1, gvmr\edgex2 - gvmr\edgex1, gvmr\edgey2 - gvmr\edgey1 )
  ; ***
  If IsImage( 1510 )
    If GetGadgetState(op1)
      CopyImage( 1510, 1509 )
    ElseIf GetGadgetState(op2)
      If ImageWidth( 1510 ) > 2480 Or ImageHeight( 1510 ) > 3508
        ResizeImage( 1510, ratioWidth(1510,2480,3508), ratioHeight(1510,2480,3508) )
      EndIf
      ; ***
      If CreateImage( 1509, 2480, 3508 ) And StartDrawing( ImageOutput( 1509 ) )
        Box(0,0,OutputWidth(),OutputHeight(),RGB(255,255,255))
        ; ***
        DrawImage( ImageID( 1510 ), (OutputWidth()-ImageWidth(1510))/ 2, (OutputHeight()-ImageHeight(1510))/ 2)
        ; ***
        StopDrawing()
      EndIf
    ElseIf GetGadgetState(op3)
      If ImageWidth( 1510 ) > 3508 Or ImageHeight( 1510 ) > 4961
        ResizeImage( 1510, ratioWidth(1510,3508,4961), ratioHeight(1510,3508,4961) )
      EndIf
      ; ***
      If CreateImage( 1509, 3508, 4961 ) And StartDrawing( ImageOutput( 1509 ) )
        Box(0,0,OutputWidth(),OutputHeight(),RGB(255,255,255))
        ; ***
        DrawImage( ImageID( 1510 ), (OutputWidth()-ImageWidth(1510))/ 2, (OutputHeight()-ImageHeight(1510))/ 2)
        ; ***
        StopDrawing()
      EndIf
    EndIf
    ; ***
    If IsImage(1509)
      Protected pth.s = ""
      pth = SaveFileRequester( "Exportieren", "", "JPEG|*.jpg;*.jpeg",0)
      ; ***
      If pth And Len(pth) > 3
        If FileSize(pth) <> -1 And FileSize(pth) <> -2
          If MessageRequester( "Bestätigen", "Es gibt bereits eine Bilddatei mit diesem Namen. Soll die Datei überschrieben werden?", #PB_MessageRequester_YesNo ) = #PB_MessageRequester_No
            ok = 0
          EndIf
        EndIf
        ; ***
        If ok = 0
          export_jpeg( op1, op2, op3 )
        ElseIf ok = 1
          SaveImage( 1509, pth, #PB_ImagePlugin_JPEG )
        EndIf
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure gui_window_icon(Window.u, Image.u)
  If IsWindow(Window) And IsImage(Image)
    CompilerSelect  #PB_Compiler_OS
      CompilerCase  #PB_OS_Linux
        gtk_window_set_icon_(WindowID(Window), ImageID(Image))
      CompilerCase #PB_OS_Windows
        ; https://www.purebasic.fr/english/viewtopic.php?f=13&t=18859&hilit=CreateIconIndirect_
        If ImageWidth(Image) <> 16 Or ImageHeight(Image) <> 16
          ResizeImage(Image,16,16)
        EndIf
        Protected ICO.ICONINFO, ICON.i
        ICO\fIcon = #False 
        ICO\xHotspot = 15 
        ICO\yHotspot = 0 
        ICO\hbmMask = ImageID(Image)
        ICO\hbmColor = ImageID(Image) 
        ICON = CreateIconIndirect_(ICO)
        SetClassLong_(WindowID(Window), #GCL_HICON, ICON) 
        ;SendMessage_(WindowID(Window), #WM_SETICON, #False, ImageID(Image))
        ;SendMessage_(WindowID(Window), #WM_SETICON, 1, ImageID(Image))
        ;SendMessage_( WindowID(Window), #STM_SETIMAGE, #IMAGE_ICON, ImageID(Image) )
      CompilerCase #PB_OS_MacOS
        ; :?:
    CompilerEndSelect
  EndIf
EndProcedure

Procedure err_ask( mode.a )
  Protected t.s = "", p.w
  ; ***
  For p = 0 To 80
    If IsGadget(#entry_shape + p)
      If EventGadget() <> draft_item
        SetGadgetState( #entry_shape + p, 0 )
      EndIf
    EndIf
  Next
  ; ***
  Select mode
    Case 0
      If gvmo\path = ""
        t = "Bitte klicken Sie auf die Schaltfläche 'Neues Objekt' und geben Sie die Objektdaten an"
      Else
        t = "Bitte klicken Sie auf die 'Neuer Entwurf' Schaltfläche und erstellen Sie einen neuen Entwurf"
      EndIf
    Case 1
      t = "Der Entwurf ist leer oder kein Element markiert!"
    Case 2
      t = "Es ist kein Objekt verfügbar!"
  EndSelect
  ; ***
  MessageRequester( "Fehler", t, #PB_MessageRequester_Warning )
EndProcedure

Procedure remove_current_object()
  If gvmr
    With gvmr
      If ListSize(\items()) > 0
        SelectElement( \items(), \index )
        ; ***
        \items()\deleted = 1
        ; ***
        draw_visual_measure_render( gvmr )
      EndIf
    EndWith
  EndIf
EndProcedure

Procedure.a add_item_to_draft()
  Protected p.w, t.s = ""
  ; ****
  If IsGadget(#label_input)
    t = Trim(GetGadgetText(#label_input))
  ElseIf gvmr\temptext
    t = gvmr\temptext
  Else
    t = "!{spObject}"
  EndIf
  ; ***
  If t = ""
    t = " "
  EndIf
  ; ***
  If IsGadget(draft_item)
    SetGadgetState( draft_item, 0 )
  EndIf
  ; ***
  If t
    If IsGadget(draft_item)
      Select draft_item
        ; ******************* RAUM ******************* ;
        Case #entry_shape +  0 : add_visual_measure_render_item( gvmr,  1, t, @element_quader(), #True )
        Case #entry_shape +  1 : add_visual_measure_render_item( gvmr,  2, t, @element_ellipse(), #True )
        Case #entry_shape +  2 : add_visual_measure_render_item( gvmr,  3, t, @element_kreis(), #True )
        Case #entry_shape +  3 : add_visual_measure_render_item( gvmr,  4, t, @element_quader_90d(), #True )
        Case #entry_shape +  4 : add_visual_measure_render_item( gvmr,  5, t, @element_sechseck_1(), #True )
        Case #entry_shape +  5 : add_visual_measure_render_item( gvmr,  6, t, @element_sechseck_2(), #True )
        Case #entry_shape +  6 : add_visual_measure_render_item( gvmr,  7, t, @element_dreieck_5(), #True )
        Case #entry_shape +  7 : add_visual_measure_render_item( gvmr,  8, t, @element_dreieck_8(), #True )
        Case #entry_shape +  8 : add_visual_measure_render_item( gvmr,  9, t, @element_dreieck_6(), #True )
        Case #entry_shape +  9 : add_visual_measure_render_item( gvmr, 10, t, @element_dreieck_7(), #True )
        Case #entry_shape + 10 : add_visual_measure_render_item( gvmr, 11, t, @element_dreieck_1(), #True )
        Case #entry_shape + 11 : add_visual_measure_render_item( gvmr, 12, t, @element_dreieck_2(), #True )
        Case #entry_shape + 12 : add_visual_measure_render_item( gvmr, 13, t, @element_dreieck_3(), #True )
        Case #entry_shape + 13 : add_visual_measure_render_item( gvmr, 14, t, @element_dreieck_4(), #True )
        Case #entry_shape + 14 : add_visual_measure_render_item( gvmr, 15, t, @element_halb_raute_1(), #True )
        Case #entry_shape + 15 : add_visual_measure_render_item( gvmr, 16, t, @element_halb_raute_3(), #True )
        Case #entry_shape + 16 : add_visual_measure_render_item( gvmr, 17, t, @element_halb_raute_2(), #True )
        Case #entry_shape + 17 : add_visual_measure_render_item( gvmr, 18, t, @element_halb_raute_4(), #True )
        Case #entry_shape + 18 : add_visual_measure_render_item( gvmr, 19, t, @element_teil_raute_1(), #True )
        Case #entry_shape + 19 : add_visual_measure_render_item( gvmr, 20, t, @element_teil_raute_3(), #True )
        Case #entry_shape + 20 : add_visual_measure_render_item( gvmr, 21, t, @element_teil_raute_4(), #True )
        Case #entry_shape + 21 : add_visual_measure_render_item( gvmr, 22, t, @element_teil_raute_2(), #True )
        ; ******************* FENSTER ******************* ;
        Case #entry_shape + 22 : add_visual_measure_render_item( gvmr, 23, "", @element_fenster_1() );, 0, element_w, element_h )
        Case #entry_shape + 23 : add_visual_measure_render_item( gvmr, 24, "", @element_fenster_2() )
        Case #entry_shape + 24 : add_visual_measure_render_item( gvmr, 25, "", @element_fenster_3() )
        ; ******************* TREPPE ******************* ;
        Case                83 : add_visual_measure_render_item( gvmr, 26, "", @element_treppe_1() )
        Case #entry_shape + 26 : add_visual_measure_render_item( gvmr, 27, "", @element_treppe_2() )
        Case #entry_shape + 27 : add_visual_measure_render_item( gvmr, 28, "", @element_treppe_3() )
        Case #entry_shape + 28 : add_visual_measure_render_item( gvmr, 29, "", @element_treppe_4() )
        Case #entry_shape + 29 : add_visual_measure_render_item( gvmr, 30, "", @element_treppe_5() )
        Case #entry_shape + 30 : add_visual_measure_render_item( gvmr, 31, "", @element_treppe_6() )
        Case #entry_shape + 31 : add_visual_measure_render_item( gvmr, 32, "", @element_treppe_7() )
        Case #entry_shape + 32 : add_visual_measure_render_item( gvmr, 33, "", @element_treppe_8() )
        Case #entry_shape + 33 : add_visual_measure_render_item( gvmr, 34, "", @element_treppe_9() )
        Case #entry_shape + 34 : add_visual_measure_render_item( gvmr, 35, "", @element_treppe_10() )
        Case #entry_shape + 35 : add_visual_measure_render_item( gvmr, 36, "", @element_treppe_11() )
        Case #entry_shape + 36 : add_visual_measure_render_item( gvmr, 37, "", @element_treppe_12() )
        Case #entry_shape + 37 : add_visual_measure_render_item( gvmr, 38, "", @element_treppe_13() )
        Case #entry_shape + 38 : add_visual_measure_render_item( gvmr, 39, "", @element_treppe_14() )
        Case #entry_shape + 39 : add_visual_measure_render_item( gvmr, 40, "", @element_treppe_15() )
        Case #entry_shape + 40 : add_visual_measure_render_item( gvmr, 41, "", @element_treppe_16() )
        Case #entry_shape + 41 : add_visual_measure_render_item( gvmr, 42, "", @element_treppe_17() )
        Case #entry_shape + 42 : add_visual_measure_render_item( gvmr, 43, "", @element_treppe_18() )
        Case #entry_shape + 43 : add_visual_measure_render_item( gvmr, 44, "", @element_treppe_19() )
        Case #entry_shape + 44 : add_visual_measure_render_item( gvmr, 45, "", @element_treppe_20() )
        Case #entry_shape + 45 : add_visual_measure_render_item( gvmr, 46, "", @element_treppe_21() )
        Case #entry_shape + 46 : add_visual_measure_render_item( gvmr, 47, "", @element_treppe_22() )
        Case #entry_shape + 47 : add_visual_measure_render_item( gvmr, 48, "", @element_treppe_23() )
        Case #entry_shape + 48 : add_visual_measure_render_item( gvmr, 49, "", @element_treppe_24() )
        Case #entry_shape + 49 : add_visual_measure_render_item( gvmr, 50, "", @element_treppe_25() )
        Case #entry_shape + 50 : add_visual_measure_render_item( gvmr, 51, "", @element_treppe_26() )
        Case #entry_shape + 51 : add_visual_measure_render_item( gvmr, 52, "", @element_treppe_27() )
        Case #entry_shape + 52 : add_visual_measure_render_item( gvmr, 53, "", @element_treppe_28() )
        Case #entry_shape + 53 : add_visual_measure_render_item( gvmr, 54, "", @element_treppe_29() )
        Case #entry_shape + 54 : add_visual_measure_render_item( gvmr, 55, "", @element_treppe_30() )
        Case #entry_shape + 55 : add_visual_measure_render_item( gvmr, 56, "", @element_treppe_31() )
        Case #entry_shape + 56 : add_visual_measure_render_item( gvmr, 57, "", @element_treppe_32() )
        Case #entry_shape + 57 : add_visual_measure_render_item( gvmr, 58, "", @element_treppe_33() )
        Case #entry_shape + 58 : add_visual_measure_render_item( gvmr, 59, "", @element_treppe_34() )
        Case #entry_shape + 59 : add_visual_measure_render_item( gvmr, 60, "", @element_treppe_35() )
        Case #entry_shape + 60 : add_visual_measure_render_item( gvmr, 61, "", @element_treppe_36() )
        Case #entry_shape + 61 : add_visual_measure_render_item( gvmr, 62, "", @element_treppe_37() )
        Case #entry_shape + 62 : add_visual_measure_render_item( gvmr, 63, "", @element_treppe_38() )
        Case #entry_shape + 63 : add_visual_measure_render_item( gvmr, 64, "", @element_treppe_39() )
        Case #entry_shape + 64 : add_visual_measure_render_item( gvmr, 65, "", @element_treppe_40() )
        Case #entry_shape + 65 : add_visual_measure_render_item( gvmr, 66, "", @element_treppe_41() )
        Case #entry_shape + 66 : add_visual_measure_render_item( gvmr, 67, "", @element_treppe_42() )
        Case #entry_shape + 67 : add_visual_measure_render_item( gvmr, 68, "", @element_treppe_43() )
        Case #entry_shape + 68 : add_visual_measure_render_item( gvmr, 69, "", @element_treppe_44() )
        Case #entry_shape + 69 : add_visual_measure_render_item( gvmr, 70, "", @element_treppe_45() )
        Case #entry_shape + 70 : add_visual_measure_render_item( gvmr, 71, "", @element_treppe_46() )
        Case #entry_shape + 71 : add_visual_measure_render_item( gvmr, 72, "", @element_treppe_47() )
        Case #entry_shape + 72 : add_visual_measure_render_item( gvmr, 73, "", @element_treppe_48() )
        ; ******************* TÜR ******************* ;
        Case           129 + 3 : add_visual_measure_render_item( gvmr, 74, "", @element_door_1() )
        Case           130 + 3 : add_visual_measure_render_item( gvmr, 75, "", @element_door_2() )
        Case           131 + 3 : add_visual_measure_render_item( gvmr, 76, "", @element_door_3() )
        Case           132 + 3 : add_visual_measure_render_item( gvmr, 77, "", @element_door_4() )
        Case           133 + 3 : add_visual_measure_render_item( gvmr, 78, "", @element_door_5() )
        Case           134 + 3 : add_visual_measure_render_item( gvmr, 79, "", @element_door_6() )
        Case           135 + 3 : add_visual_measure_render_item( gvmr, 80, "", @element_door_7() )
        Case           136 + 3 : add_visual_measure_render_item( gvmr, 81, "", @element_door_8() )
        Case           137 + 3 : add_visual_measure_render_item( gvmr, 82, "", @element_door_9() )
        Case           138 + 3 : add_visual_measure_render_item( gvmr, 83, "", @element_door_10() )
        Case           139 + 3 : add_visual_measure_render_item( gvmr, 84, "", @element_door_11() )
        Case           140 + 3 : add_visual_measure_render_item( gvmr, 85, "", @element_door_12() )
        ; ******************* PFEIL ******************* ;
        Case           149 + 3 : add_visual_measure_render_item( gvmr, 86, "", @element_pfeil_1() )
        Case           150 + 3 : add_visual_measure_render_item( gvmr, 87, "", @element_pfeil_2() )
        Case           151 + 3 : add_visual_measure_render_item( gvmr, 88, "", @element_pfeil_3() )
        Case           152 + 3 : add_visual_measure_render_item( gvmr, 89, "", @element_pfeil_4() )
        ; ******************* AUFZUG ******************* ;
        Case           156 + 5 : add_visual_measure_render_item( gvmr, 90, t, @element_aufzug_1() )
        Case           157 + 5 : add_visual_measure_render_item( gvmr, 91, t, @element_aufzug_2() )
        Case           158 + 5 : add_visual_measure_render_item( gvmr, 92, t, @element_aufzug_3() )
        Case           159 + 5 : add_visual_measure_render_item( gvmr, 93, t, @element_aufzug_4() )
        ; ******************* STÜTZE ******************* ;
        Case           160 + 6 : add_visual_measure_render_item( gvmr, 94, "", @element_stuetze_1() )
        Case           161 + 6 : add_visual_measure_render_item( gvmr, 95, "", @element_stuetze_2() )
        ; ******************* KAMIN ******************* ;
        Case           162 + 7 : add_visual_measure_render_item( gvmr, 96, "", @element_kamin() )
        ; ******************* TEXT & MARKER ******************* ;
        Case               157 : add_visual_measure_render_item( gvmr, 97, t, @element_text() )
        Case               158 : add_visual_measure_render_item( gvmr, 98, Str(gvmr\numbering[0]), @element_number_1() )
        Case               159 : add_visual_measure_render_item( gvmr, 99, Str(gvmr\numbering[1]), @element_number_2() )
        ; ******************* DACHSCHRÄGEN ******************* ;
        Case               173 : add_visual_measure_render_item( gvmr,100, "", @element_dachshregen_1() )
        Case               174 : add_visual_measure_render_item( gvmr,101, "", @element_dachshregen_2() )
      EndSelect
      ; ***
      ProcedureReturn 1
    EndIf
  EndIf
  ; ***
  ProcedureReturn 0
EndProcedure

Procedure show_dlgSwichtObject()
  Protected p.w, f.s
  Protected t.s = "", m.a = 0, ll.s, rr.s
  Protected a.s, b.s, c.s, d.s, e.l = 0
  ; ***
  If OpenWindow( #fenster7, 0, 0, 520, 250, "Objekt wechseln", #PB_Window_SystemMenu|#PB_Window_WindowCentered, WindowID(#fenster2) )
    gui_window_icon( #fenster7, 951 )
    ; ***
    ListIconGadget( 920, 10, 10, 500, 160, "Kunde", 120, #PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect )
    AddGadgetColumn( 920, 2, "Adresse", 120 )
    AddGadgetColumn( 920, 3, "PLZ", 80 )
    AddGadgetColumn( 920, 4, "Ort", 120 )
    AddGadgetColumn( 920, 5, "Id", 50 )
    ; ***
    ButtonGadget( 921, WindowWidth(#fenster7) - 110, WindowHeight(#fenster7) - 40, 100, 30, "Wechseln" )
    ; ***
    ButtonGadget( 922, WindowWidth(#fenster7) - 220, WindowHeight(#fenster7) - 40, 100, 30, "Abbrechen" )
    ; ***
    AddKeyboardShortcut( #fenster7, #PB_Key_Escape, #hk_escape )
    ; ***
    If ExamineDirectory(0, datPath, "*.*")  
      While NextDirectoryEntry(0)
        If DirectoryEntryType(0) = #PB_DirectoryEntry_File
          f = DirectoryEntryName(0)
          ; ***
          f = datPath + #sysChar + f
          ; ***
          Select LCase(GetExtensionPart(f))
            Case "mit"
              If ReadFile( 10, f, #PB_UTF8 )
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
                              Case "customer" : a = rr
                              Case "address" : b = rr
                              Case "postalcode" : c = rr
                              Case "town" : d = rr
                            EndSelect
                          Case 2, 3, 4
                            AddGadgetItem( 920, -1, a + Chr(10) + b + Chr(10) + c + Chr(10) + d + Chr(10) + Str(e) + Chr(10) + f )
                            ; ***
                            a = ""
                            b = ""
                            c = ""
                            d = ""
                            ; ***
                            e + 1
                            ; ***
                            Break
                        EndSelect
                    EndSelect
                  EndIf
                Wend
                ; ***
                CloseFile(10)
              EndIf
          EndSelect
        EndIf
      Wend
      FinishDirectory(0)
    EndIf
  EndIf
EndProcedure

Procedure event_dlgSwichtObject( evt.i )
  Protected p.w
  ; ***
  If Not IsWindow(#fenster7) : ProcedureReturn : EndIf
  If EventWindow() <> #fenster7 Or GetActiveWindow() <> #fenster7 : ProcedureReturn : EndIf
  ; ***
  Select evt
    Case #PB_Event_CloseWindow
      CloseWindow(#fenster7)
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 921 ; Wechseln
          If GetGadgetItemText(920, GetGadgetState(920), 5)
            load_from_file( gvmo, GetGadgetItemText(920, GetGadgetState(920), 5) )
            ; ***
            ___loadIn()
            ; ***
            CloseWindow(#fenster7)
          EndIf
        Case 922 ; Abbrechen
          CloseWindow(#fenster7)
      EndSelect
  EndSelect
EndProcedure

Procedure show_export()
  If OpenWindow( #fenster12, 0, 0, 230, 160, "Exportieren", #PB_Window_Invisible|#PB_Window_SystemMenu|#PB_Window_WindowCentered, WindowID(#fenster2) )
    gui_window_icon( #fenster12, 961 )
    ; ***
    OptionGadget( 840, 10, 10, 180, 30, "Pixelgenauer JPEG" )
    OptionGadget( 841, 10, 40, 180, 30, "A4 JPEG" )
    OptionGadget( 842, 10, 70, 180, 30, "A3 JPEG" )
    ; ***
    SetGadgetState( 840, 1 )
    SetGadgetState( 841, 0 )
    SetGadgetState( 842, 0 )
    ; ***
    ButtonGadget( 843, WindowWidth(#fenster12) - 110, WindowHeight(#fenster12) - 40, 100, 30, "Exportieren" )
    ; ***
    ButtonGadget( 844, WindowWidth(#fenster12) - 220, WindowHeight(#fenster12) - 40, 100, 30, "Abbrechen" )
    ; ***
    AddKeyboardShortcut( #fenster12, #PB_Key_Escape, #hk_escape )
    ; ***
    HideWindow(#fenster12,0)
  EndIf
EndProcedure

Procedure event_export( evt.i )
  Protected p.w
  ; ***
  If Not IsWindow(#fenster12) : ProcedureReturn : EndIf
  If EventWindow() <> #fenster12 Or GetActiveWindow() <> #fenster12 : ProcedureReturn : EndIf
  ; ***
  Select evt
    Case #PB_Event_CloseWindow
      CloseWindow(#fenster12)
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 843 ; Wechseln
          export_jpeg( 840, 841, 842 )
          ; ***
          CloseWindow(#fenster12)
        Case 844 ; Abbrechen
          CloseWindow(#fenster12)
      EndSelect
  EndSelect
EndProcedure

Procedure show_send()
  If OpenWindow( #fenster13, 0, 0, 220, 70, "Daten senden", #PB_Window_Invisible|#PB_Window_SystemMenu|#PB_Window_WindowCentered, WindowID(#fenster2) )
    gui_window_icon( #fenster13, 9658 )
    ; ***
    TextGadget( 850, 10, 10, 180, 40, "Verbindungsaufbau..." )
    ; ***
    ButtonGadget( 851, (WindowWidth(#fenster12) - 100) / 2, WindowHeight(#fenster12) - 40, 100, 30, "Abbrechen" )
    ; ***
    AddKeyboardShortcut( #fenster13, #PB_Key_Escape, #hk_escape )
    ; ***
    HideWindow(#fenster13,0)
  EndIf
EndProcedure

Procedure event_send( evt.i )
  Protected p.w
  ; ***
  If Not IsWindow(#fenster13) : ProcedureReturn : EndIf
  If EventWindow() <> #fenster13 Or GetActiveWindow() <> #fenster13 : ProcedureReturn : EndIf
  ; ***
  Select evt
    Case #PB_Event_CloseWindow
      CloseWindow(#fenster13)
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 851 ; Abbrechen
          CloseWindow(#fenster13)
      EndSelect
  EndSelect
EndProcedure

Procedure show_dlgObjekt()
  If OpenWindow( #fenster6, 0, 0, 400, 360, "Das Objekt", #PB_Window_Invisible|#PB_Window_SystemMenu|#PB_Window_WindowCentered, WindowID(#fenster2) )
    gui_window_icon( #fenster6, 950 )
    ; ***
    TextGadget( 900, 10, 10, 180, 30, "Mitarbeiter:" )
    StringGadget( 910, 190, 10, 200, 24, "" )
    ; ***
    TextGadget( 901, 10, 40, 180, 30, "Auftragsnummer:" )
    StringGadget( 911, 190, 40, 200, 24, "" )
    ; ***
    TextGadget( 902, 10, 70, 180, 30, "Straße, HNr:" )
    StringGadget( 912, 190, 70, 200, 24, "" )
    ; ***
    TextGadget( 903, 10, 100, 180, 30, "PLZ:" )
    StringGadget( 913, 190, 100, 200, 24, "" )
    ; ***
    TextGadget( 904, 10, 130, 180, 30, "Ort:" )
    StringGadget( 914, 190, 130, 200, 24, "" )
    ; ***
    TextGadget( 907, 10, 160, 180, 30, "Abgabetermin:" )
    DateGadget( 915, 190, 160, 200, 24 )
    ; ***
    TextGadget( 908, 10, 190, 180, 30, "Notiz:" )
    EditorGadget( 916, 190, 190, 200, 120 )
    ; ***
    ButtonGadget( 905, WindowWidth(#fenster6) - 110, WindowHeight(#fenster6) - 40, 100, 30, "Erstellen" )
    ; ***
    ButtonGadget( 906, WindowWidth(#fenster6) - 220, WindowHeight(#fenster6) - 40, 100, 30, "Abbrechen" )
    ; ***
    AddKeyboardShortcut( #fenster6, #PB_Key_Escape, #hk_escape )
    ; ***
    HideWindow(#fenster6,0)
  EndIf
EndProcedure

Procedure event_dlgObjekt( evt.i )
  Protected p.w, pth.s
  ; ***
  If Not IsWindow(#fenster6) : ProcedureReturn : EndIf
  If EventWindow() <> #fenster6 Or GetActiveWindow() <> #fenster6 : ProcedureReturn : EndIf
  ; ***
  Select evt
    Case #PB_Event_CloseWindow
      CloseWindow(#fenster6)
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 905
          If Trim(GetGadgetText(910)) = "" Or Trim(GetGadgetText(911)) = "" Or Trim(GetGadgetText(912)) = "" Or Trim(GetGadgetText(913)) = "" Or Trim(GetGadgetText(914)) = "" 
            MessageRequester( "Hinweis", "Die Felder Kunde, Straße, PLZ und Ort sind Pflichtfelder und müssen angegeben werden", #PB_MessageRequester_Info )
          Else
            With gvmo
              \object = Trim(GetGadgetText(910))
              \order = Trim(GetGadgetText(911))
              \address = Trim(GetGadgetText(912))
              \postalcode = Trim(GetGadgetText(913))
              \town = Trim(GetGadgetText(914))
              \deadline = FormatDate("%dd.%mm.%yyyy",GetGadgetState(915))
              \notice = Trim(GetGadgetText(916))
              ; ***
              If Val(\postalcode) <= 0
                MessageRequester( "Hinweis", "Die Postleitzahl muss eine gültige Zahl sein", #PB_MessageRequester_Info )
              Else
                pth = datPath
                ; ***
                CompilerIf #PB_Compiler_OS = #PB_OS_Windows
                  If Right( pth, 1 ) <> "\"
                    pth + "\"
                  EndIf
                CompilerElse
                  If Right( pth, 1 ) <> "/"
                    pth + "/"
                  EndIf
                CompilerEndIf
                ; ***
                pth + \object + " - " + FormatDate("%dd-%mm-%yyyy",Date())
                ; ***
                StatusBarText( 20, 0, \order )
                StatusBarText( 20, 1, \address )
                StatusBarText( 20, 2, \postalcode )
                StatusBarText( 20, 3, \town )
                StatusBarText( 20, 4, "<Kein Entwurf>" )
                ; ***
                \path = pth + ".mit"
                ; ***
                CloseWindow(#fenster6)
              EndIf
            EndWith
          EndIf
        Case 906
          CloseWindow(#fenster6)
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
        Case #hk_escape
          CloseWindow(#fenster6)
      EndSelect
  EndSelect
EndProcedure

Procedure show_dlgOpen()
  Protected p.w, f.s
  Protected t.s = "", m.a = 0, ll.s, rr.s
  Protected a.s, b.s, c.s, d.s, e.l = 0
  ; ***
  If OpenWindow( #fenster11, 0, 0, 600, 420, "Objekt laden", #PB_Window_Invisible|#PB_Window_SystemMenu|#PB_Window_WindowCentered, WindowID(#fenster2) )
    gui_window_icon( #fenster11, 953 )
    ; ***
    ListIconGadget( 801, 10, 10, 580, 360, "Kunde", 180, #PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect )
    AddGadgetColumn( 801, 2, "Adresse", 120 )
    AddGadgetColumn( 801, 3, "PLZ", 80 )
    AddGadgetColumn( 801, 4, "Ort", 120 )
    AddGadgetColumn( 801, 5, "Id", 50 )
    AddGadgetColumn( 801, 6, "Datei", 10 )
    ; ***
    ButtonGadget( 802, 10, WindowHeight(#fenster11) - 40, 100, 30, "Durchsuchen" )
    ; ***
    GadgetToolTip( 802, "Den Computer durchsuchen..." )
    ; ***
    ButtonGadget( 803, WindowWidth(#fenster11) - 110, WindowHeight(#fenster11) - 40, 100, 30, "Öffnen" )
    ; ***
    ButtonGadget( 804, WindowWidth(#fenster11) - 220, WindowHeight(#fenster11) - 40, 100, 30, "Abbrechen" )
    ; ***
    If ExamineDirectory(0, datPath, "*.*")  
      While NextDirectoryEntry(0)
        If DirectoryEntryType(0) = #PB_DirectoryEntry_File
          f = DirectoryEntryName(0)
          ; ***
          f = datPath + #sysChar + f
          ; ***
          Select LCase(GetExtensionPart(f))
            Case "mit"
              If ReadFile( 10, f, #PB_UTF8 )
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
                              Case "customer" : a = rr
                              Case "address" : b = rr
                              Case "postalcode" : c = rr
                              Case "town" : d = rr
                            EndSelect
                          Case 2, 3, 4
                            AddGadgetItem( 801, -1, a + Chr(10) + b + Chr(10) + c + Chr(10) + d + Chr(10) + Str(e) + Chr(10) + f )
                            ; ***
                            a = ""
                            b = ""
                            c = ""
                            d = ""
                            ; ***
                            e + 1
                            ; ***
                            Break
                        EndSelect
                    EndSelect
                  EndIf
                Wend
                ; ***
                CloseFile(10)
              EndIf
          EndSelect
        EndIf
      Wend
      FinishDirectory(0)
    EndIf
    ; ***
    HideWindow(#fenster11,0)
  EndIf
EndProcedure

Procedure event_dlgOpen( evt.i )
  Protected p.w, pth.s
  Protected t.s = "", m.a = 0, ll.s, rr.s
  Protected a.s, b.s, c.s, d.s, e.l = 0
  Protected __a.s, __b.s, __c.s, __d.s
  ; ***
  If Not IsWindow(#fenster11) : ProcedureReturn : EndIf
  If EventWindow() <> #fenster11 Or GetActiveWindow() <> #fenster11 : ProcedureReturn : EndIf
  ; ***
  Select evt
    Case #PB_Event_CloseWindow
      CloseWindow(#fenster11)
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 802
          If gvmo\path
            If FileSize(gvmo\path) <> -1 And FileSize(gvmo\path) <> -2
              Select MessageRequester( "Objekt laden", "Sollen die Änderungen am aktuellen Objekt gespeichert werden?", #PB_MessageRequester_YesNoCancel )
                Case #PB_MessageRequester_Yes
                  save_to_file( gvmo )
                  ; ***
                  pth = PathRequester("Objektordner wählen", "")
                  ; ***
                  If pth And FileSize(pth) = -2
                    load_from_file( gvmo, pth )
                    ; ***
                    ___loadIn()
                  EndIf
                Case #PB_MessageRequester_No
                  pth = OpenFileRequester("Objektdatei öffnen", "", "MeasureIT Objektdatei|*.mit", 0)
                  ; ***
                  If pth And FileSize(pth) <> -1 And FileSize(pth) <> -2
                    If LCase(GetExtensionPart(pth)) = "mit"
                      load_from_file( gvmo, pth )
                      ; ***
                      ___loadIn()
                    Else
                      MessageRequester( "Abbruch", "Datei kann nicht geladen werden, da der Datentyp nicht unterstützt wird!", #PB_MessageRequester_Info )
                    EndIf
                  EndIf
              EndSelect
            Else
              show_dlgOpen()
            EndIf
          Else
            pth = OpenFileRequester("Objektdatei öffnen", "", "MeasureIT Objektdatei|*.mit", 0)
            ; ***
            If pth And FileSize(pth) <> -1 And FileSize(pth) <> -2
              If LCase(GetExtensionPart(pth)) = "mit"
                load_from_file( gvmo, pth )
                ; ***
                ___loadIn()
              Else
                MessageRequester( "Abbruch", "Datei kann nicht geladen werden, da der Datentyp nicht unterstützt wird!", #PB_MessageRequester_Info )
              EndIf
            EndIf
          EndIf
        Case 803
          If CountGadgetItems(801) > 0
            If GetGadgetText(801) And GetGadgetState(801) >= 0
Debug GetGadgetItemText(801,GetGadgetState(801), 5 )
              gvmo\path = GetGadgetItemText(801,GetGadgetState(801), 5 )
              If FileSize(gvmo\path) <> -1 And FileSize(gvmo\path) <> -2
                Select MessageRequester( "Objekt laden", "Sollen die Änderungen am aktuellen Objekt gespeichert werden?", #PB_MessageRequester_YesNoCancel )
                  Case #PB_MessageRequester_Yes
                    save_to_file( gvmo )
                    ; ***
                    load_from_file( gvmo, GetGadgetItemText(801,GetGadgetState(801), 5 ) )
                    ; ***
                    gvmo\path = GetGadgetItemText(801,GetGadgetState(801), 5 )
                    ; ***
                    ___loadIn()
                    ; ***
                    CloseWindow(#fenster11)
                  Case #PB_MessageRequester_No
                    load_from_file( gvmo, GetGadgetItemText(801,GetGadgetState(801), 5 ) )
                    ; ***
                    ___loadIn()
                    ; ***
                    CloseWindow(#fenster11)
                EndSelect
              EndIf
            EndIf
          EndIf
        Case 804
          CloseWindow(#fenster11)
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
        Case #hk_enter
          ; ***
          CloseWindow(#fenster11)
        Case #hk_escape
          CloseWindow(#fenster11)
      EndSelect
  EndSelect
EndProcedure

Procedure show_dlgEdit()
  If OpenWindow( #fenster8, 0, 0, 400, 360, "Element bearbeiten", #PB_Window_Invisible|#PB_Window_SystemMenu|#PB_Window_WindowCentered, WindowID(#fenster2) )
    gui_window_icon( #fenster8, 957 )
    ; ***
    TextGadget( 930, 10, 10, 180, 30, "Bezeichner:" )
    ComboBoxGadget( 940, 190, 10, 200, 24, #PB_ComboBox_Editable )
    AddGadgetItem( 940, -1, "Küche" )
    AddGadgetItem( 940, -1, "Wohnen" )
    AddGadgetItem( 940, -1, "Essen" )
    AddGadgetItem( 940, -1, "Schlafen" )
    AddGadgetItem( 940, -1, "Arbeiten" )
    AddGadgetItem( 940, -1, "Kind" )
    AddGadgetItem( 940, -1, "Hobby" )
    AddGadgetItem( 940, -1, "Abstellen" )
    AddGadgetItem( 940, -1, "Terrasse" )
    AddGadgetItem( 940, -1, "Loggia" )
    AddGadgetItem( 940, -1, "Balkon" )
    AddGadgetItem( 940, -1, "Garage" )
    AddGadgetItem( 940, -1, "Schuppen" )
    AddGadgetItem( 940, -1, "Werkstatt" )
    AddGadgetItem( 940, -1, "WC" )
    AddGadgetItem( 940, -1, "Gäste WC" )
    AddGadgetItem( 940, -1, "Bad" )
    AddGadgetItem( 940, -1, "Gäste" )
    AddGadgetItem( 940, -1, "Technik" )
    AddGadgetItem( 940, -1, "Hauswirtschaft" )
    AddGadgetItem( 940, -1, "Hausanschluss" )
    AddGadgetItem( 940, -1, "Keller" )
    AddGadgetItem( 940, -1, "Diele" )
    AddGadgetItem( 940, -1, "Flur" )
    AddGadgetItem( 940, -1, "Eingang" )
    AddGadgetItem( 940, -1, "Treppenhaus" )
    AddGadgetItem( 940, -1, "Offener Wohnraum" )
    AddGadgetItem( 940, -1, "Dachboden" )
    AddGadgetItem( 940, -1, "Spitzboden" )
    AddGadgetItem( 940, -1, "Carpot" )
    AddGadgetItem( 940, -1, "Gartenhaus" )
    AddGadgetItem( 940, -1, "Stahl" )
    AddGadgetItem( 940, -1, "Lager" )
    AddGadgetItem( 940, -1, "Geschäft" )
    AddGadgetItem( 940, -1, "Laden" )
    AddGadgetItem( 940, -1, "Arbeitszimmer" )
    AddGadgetItem( 940, -1, "Wohnzimmer" )
    AddGadgetItem( 940, -1, "Kinderzimmer" )
    AddGadgetItem( 940, -1, "Esszimmer" )
    AddGadgetItem( 940, -1, "Badezimmer" )
    AddGadgetItem( 940, -1, "WC, Bad" )
    AddGadgetItem( 940, -1, "WC" )
    AddGadgetItem( 940, -1, "Flur" )
    AddGadgetItem( 940, -1, "Stellraum" )
    AddGadgetItem( 940, -1, "Lagerraum" )
    AddGadgetItem( 940, -1, "Waschraum" )
    AddGadgetItem( 940, -1, "Salon" )
    AddGadgetItem( 940, -1, "WG-Zimmer" )
    AddGadgetItem( 940, -1, "Büroraum" )
    AddGadgetItem( 940, -1, "Technikraum" )
    AddGadgetItem( 940, -1, "Kühlraum" )
    AddGadgetItem( 940, -1, "Balkon" )
    AddGadgetItem( 940, -1, "Terasse" )
    AddGadgetItem( 940, -1, "Veranda" )
    ; ***
    TextGadget( 931, 10, 40, 180, 30, "X-Achse:" )
    StringGadget( 941, 190, 40, 200, 24, "" )
    ; ***
    TextGadget( 932, 10, 70, 180, 30, "Y-Achse:" )
    StringGadget( 942, 190, 70, 200, 24, "" )
    ; ***
    TextGadget( 933, 10, 100, 180, 30, "Breite:" )
    StringGadget( 943, 190, 100, 200, 24, "" )
    ; ***
    TextGadget( 934, 10, 130, 180, 30, "Höhe:" )
    StringGadget( 944, 190, 130, 200, 24, "" )
    ; ***
    TextGadget( 935, 10, 160, 180, 30, "Maß-Einheit:" )
    ComboBoxGadget( 945, 190, 160, 200, 24 )
    AddGadgetItem( 945, -1, "<Keine>" )
    AddGadgetItem( 945, -1, "mm" )
    AddGadgetItem( 945, -1, "cm" )
    AddGadgetItem( 945, -1, "dm" )
    AddGadgetItem( 945, -1, "m" )
    AddGadgetItem( 945, -1, "Zoll" )
    AddGadgetItem( 945, -1, "Punkt" )
    AddGadgetItem( 945, -1, "Pixel" )
    SetGadgetState( 945, 0 )
    ; ***
    TextGadget( 1401, 10, 190, 180, 30, "Oben (1 cm):" )
    TrackBarGadget( 1411, 190, 190, 200, 24, 1, 50, #PB_TrackBar_Ticks )
    ; ***
    TextGadget( 1402, 10, 220, 180, 30, "Unten (1 cm):" )
    TrackBarGadget( 1412, 190, 220, 200, 24, 1, 50, #PB_TrackBar_Ticks )
    ; ***
    TextGadget( 1403, 10, 250, 180, 30, "Links (1 cm):" )
    TrackBarGadget( 1413, 190, 250, 200, 24, 1, 50, #PB_TrackBar_Ticks )
    ; ***
    TextGadget( 1404, 10, 280, 180, 30, "Rechts (1 cm):" )
    TrackBarGadget( 1414, 190, 280, 200, 24, 1, 50, #PB_TrackBar_Ticks )
    ; ***
    ButtonGadget( 946, WindowWidth(#fenster8) - 110, WindowHeight(#fenster8) - 40, 100, 30, "Ändern" )
    ; ***
    ButtonGadget( 947, WindowWidth(#fenster8) - 220, WindowHeight(#fenster8) - 40, 100, 30, "Abbrechen" )
    ; ***
    CheckBoxGadget( 1415, 10, WindowHeight(#fenster8) - 40, 100, 30, "Sperren" )
    ; ***
    AddKeyboardShortcut( #fenster8, #PB_Key_Escape, #hk_escape )
    ; ***
    If gvmr
      With gvmr
        If ListSize(\items()) > 0
          SelectElement( \items(), \index )
          ; ***
          If ListIndex( \items() ) >= 0
            Select \items()\type
              Case 1 To 22
                SetGadgetText( 940, \items()\label )
              Default
                DisableGadget( 940, 1 )
                SetGadgetText( 940, "" )
            EndSelect
            ; ***
            SetGadgetText( 941, ReplaceString(StrD(\items()\x,2),".",",") )
            SetGadgetText( 942, ReplaceString(StrD(\items()\y,2),".",",") )
            SetGadgetText( 943, ReplaceString(StrD(\items()\w - \items()\x,2),".",",") )
            SetGadgetText( 944, ReplaceString(StrD(\items()\h - \items()\y,2),".",",") )
            ; ***
            _cur_etop = \items()\etop
            _cur_ebottom = \items()\ebottom
            _cur_eleft = \items()\eleft
            _cur_eright = \items()\eright
            ; ***
            SetGadgetState( 945, \items()\measure )
            ; ***
            SetGadgetState( 1411, _cur_etop )
            SetGadgetState( 1412, _cur_ebottom )
            SetGadgetState( 1413, _cur_eleft )
            SetGadgetState( 1414, _cur_eright )
            ; ***
            SetGadgetText( 1401, "Oben (" + Str(GetGadgetState(1411)) + " cm):" )
            SetGadgetText( 1402, "Unten (" + Str(GetGadgetState(1412)) + " cm):" )
            SetGadgetText( 1403, "Links (" + Str(GetGadgetState(1413)) + " cm):" )
            SetGadgetText( 1404, "Rechts (" + Str(GetGadgetState(1414)) + " cm):" )
            ; ***
            SetGadgetState( 1415, \items()\lock )
            ; ***
            current_element_type = \items()\type
            ; ***
            Select \items()\type
              Case 1 To 22
                DisableGadget( 1401, 0 )
                DisableGadget( 1402, 0 )
                DisableGadget( 1403, 0 )
                DisableGadget( 1404, 0 )
                DisableGadget( 1411, 0 )
                DisableGadget( 1412, 0 )
                DisableGadget( 1413, 0 )
                DisableGadget( 1414, 0 )
              Default
                DisableGadget( 1401, 1 )
                DisableGadget( 1402, 1 )
                DisableGadget( 1403, 1 )
                DisableGadget( 1404, 1 )
                DisableGadget( 1411, 1 )
                DisableGadget( 1412, 1 )
                DisableGadget( 1413, 1 )
                DisableGadget( 1414, 1 )
            EndSelect
            ; ***
            DisableGadget(#canvas2, 1)
          EndIf
        EndIf
      EndWith
    EndIf
    ; ***
    HideWindow(#fenster8,0)
  EndIf
EndProcedure

Procedure event_dlgEdit( evt.i )
  Protected p.w
  ; ***
  If Not IsWindow(#fenster8) : ProcedureReturn : EndIf
  If EventWindow() <> #fenster8 Or GetActiveWindow() <> #fenster8 : ProcedureReturn : EndIf
  ; ***
  Select evt
    Case #PB_Event_CloseWindow
      DisableGadget(#canvas2, 0)
      ; ***
      CloseWindow(#fenster8)
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 1411 ; Oben
          SetGadgetText( EventGadget() - 10, "Oben (" + Str(GetGadgetState(EventGadget())) + " cm):" )
        Case 1412 ; Oben
          SetGadgetText( EventGadget() - 10, "Unten (" + Str(GetGadgetState(EventGadget())) + " cm):" )
        Case 1413 ; Oben
          SetGadgetText( EventGadget() - 10, "Links (" + Str(GetGadgetState(EventGadget())) + " cm):" )
        Case 1414 ; Oben
          SetGadgetText( EventGadget() - 10, "Rechts (" + Str(GetGadgetState(EventGadget())) + " cm):" )
        Case 946 ; Speichern
          If gvmr
            With gvmr
              If ListSize(\items()) > 0
                SelectElement( \items(), \index )
                ; ***
                If ListIndex( \items() ) >= 0
                  Select \items()\type
                    Case 1 To 22
                      \items()\label = GetGadgetText( 940 )
                    Default
                      DisableGadget( 940, 1 )
                      SetGadgetText( 940, "" )
                  EndSelect
                  ; ***
                  \items()\x = ValD(ReplaceString(GetGadgetText( 941 ),",","."))
                  \items()\y = ValD(ReplaceString(GetGadgetText( 942 ),",","."))
                  \items()\w = \items()\x + ValD(ReplaceString(GetGadgetText( 943 ),",","."))
                  \items()\h = \items()\y + ValD(ReplaceString(GetGadgetText( 944 ),",","."))
                  ; ***
                  If \items()\w < 1 : \items()\w = 1 : EndIf
                  If \items()\h < 1 : \items()\h = 1 : EndIf
                  ; ***
                  \items()\measure = GetGadgetState( 945 )
                  ; ***
                  \items()\eTop = GetGadgetState(1411)
                  \items()\eBottom = GetGadgetState(1412) 
                  \items()\eLeft = GetGadgetState(1413)
                  \items()\eRight = GetGadgetState(1414)
                  ; ***
                  \items()\lock = GetGadgetState( 1415 )
                  ; ***
                  draw_visual_measure_render( gvmr )
                EndIf
              EndIf
            EndWith
          EndIf
          ; ***
          DisableGadget(#canvas2, 0)
          ; ***
          CloseWindow(#fenster8)
        Case 947 ; Abbrechen
          DisableGadget(#canvas2, 0)
          ; ***
          CloseWindow(#fenster8)
      EndSelect
  EndSelect
EndProcedure

Procedure reload_setup()
  Protected l.s, r.s
  ; ***
  If FileSize(prePath + "conf.ini") <> -1 And FileSize(prePath + "conf.ini")
    If ReadFile( 10, prePath + "conf.ini", #PB_UTF8 )
      While Eof(10) = 0
        r = ReadString(10)
        ; ***
        If CountString( r, "=" )
          l = Trim(pick( 0, "=", r ))
          r = Trim(pick( 1, "=", r ))
          ; ***
          Select l
            Case "lang" : setup_lang = Val(r)
            Case "meas" : setup_meas = Val(r)
            Case "digi" : setup_digi = Val(r)
            Case "path" : setup_path = r
            Case "user" : setup_user = r
            Case "pass" : setup_pass = r
          EndSelect
        EndIf
      Wend
      ; ***
      CloseFile( 10 )
    EndIf
  EndIf
EndProcedure

Procedure show_dlgSetup()
  Protected l.s, r.s
  ; ***
  If OpenWindow( #fenster9, 0, 0, 400, 240, "Einstellungen", #PB_Window_Invisible|#PB_Window_SystemMenu|#PB_Window_WindowCentered, WindowID(#fenster2) )
    gui_window_icon( #fenster9, 959 )
    ; ***
    TextGadget( 950, 10, 10, 180, 30, "Sprache:" )
    ComboBoxGadget( 960, 190, 10, 200, 24 )
    ; ***
    AddGadgetItem( 960, -1, "(En) English" )
    AddGadgetItem( 960, -1, "(De) Deutsch" )
    AddGadgetItem( 960, -1, "(Tr) Türkçe" )
    ; ***
    SetGadgetState( 960, 1 )
    ; ***
    TextGadget( 951, 10, 40, 180, 30, "Standard Maßeinheit:" )
    ComboBoxGadget( 961, 190, 40, 200, 24 )
    ; ***
    AddGadgetItem( 961, -1, "<Keine>" )
    AddGadgetItem( 961, -1, "mm" )
    AddGadgetItem( 961, -1, "cm" )
    AddGadgetItem( 961, -1, "dm" )
    AddGadgetItem( 961, -1, "m" )
    AddGadgetItem( 961, -1, "Zoll" )
    AddGadgetItem( 961, -1, "Punkt" )
    AddGadgetItem( 961, -1, "Pixel" )
    ; ***
    SetGadgetState( 961, 0 )
    ; ***
    TextGadget( 952, 10, 70, 180, 30, "Kommazahl-Trenner:" )
    ComboBoxGadget( 962, 190, 70, 200, 24 )
    ; ***
    AddGadgetItem( 962, -1, "Komma (  ,  )" )
    AddGadgetItem( 962, -1, "Punkt (  .  )" )
    ; ***
    SetGadgetState( 962, 0 )
    ; ***
    TextGadget( 953, 10, 100, 180, 30, "Server-Pfad:" )
    StringGadget( 963, 190, 100, 200, 24, "" )
    ; ***
    TextGadget( 956, 10, 130, 180, 30, "Benutzer:" )
    StringGadget( 966, 190, 130, 200, 24, "" )
    ; ***
    TextGadget( 957, 10, 160, 180, 30, "Kennwort:" )
    StringGadget( 967, 190, 160, 200, 24, "" )
    ; ***
    ButtonGadget( 964, WindowWidth(#fenster9) - 110, WindowHeight(#fenster9) - 40, 100, 30, "Speichern" )
    ; ***
    ButtonGadget( 965, WindowWidth(#fenster9) - 220, WindowHeight(#fenster9) - 40, 100, 30, "Abbrechen" )
    ; ***
    AddKeyboardShortcut( #fenster9, #PB_Key_Escape, #hk_escape )
    ; ***
    If FileSize(prePath + "conf.ini") <> -1 And FileSize(prePath + "conf.ini")
      If ReadFile( 10, prePath + "conf.ini", #PB_UTF8 )
        While Eof(10) = 0
          r = ReadString(10)
          ; ***
          If CountString( r, "=" )
            l = Trim(pick( 0, "=", r ))
            r = Trim(pick( 1, "=", r ))
            ; ***
            Select l
              Case "lang" : SetGadgetState(960, Val(r))
              Case "meas" : SetGadgetState(961, Val(r))
              Case "digi" : SetGadgetState(962, Val(r))
              Case "path" : SetGadgetText(963, r)
              Case "user" : SetGadgetText(966, r)
              Case "pass" : SetGadgetText(967, r)
            EndSelect
          EndIf
        Wend
        ; ***
        CloseFile( 10 )
      EndIf
    EndIf
    ; ***
    HideWindow(#fenster9,0)
  EndIf
EndProcedure

Procedure event_dlgSetup( evt.i )
  Protected p.w
  ; ***
  If Not IsWindow(#fenster9) : ProcedureReturn : EndIf
  If EventWindow() <> #fenster9 Or GetActiveWindow() <> #fenster9 : ProcedureReturn : EndIf
  ; ***
  Select evt
    Case #PB_Event_CloseWindow
      CloseWindow(#fenster9)
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 964 ; Speichern
          If FileSize(prePath + "conf.ini") <> -1 And FileSize(prePath + "conf.ini")
            RenameFile( prePath + "conf.ini", prePath + "conf.bak" )
          EndIf
          ; ***
          If CreateFile( 10, prePath + "conf.ini", #PB_UTF8 )
            WriteStringN( 10, "@%" )
            WriteStringN( 10, "lang=" + Str(GetGadgetState(960)) )
            WriteStringN( 10, "meas=" + Str(GetGadgetState(961)) )
            WriteStringN( 10, "digi=" + Str(GetGadgetState(962)) )
            WriteStringN( 10, "path=" + GetGadgetText(963) )
            WriteStringN( 10, "user=" + GetGadgetText(966) )
            WriteStringN( 10, "pass=" + GetGadgetText(967) )
            ; ***
            CloseFile( 10 )
            ; ***
            If FileSize(prePath + "conf.bak") <> -1 And FileSize(prePath + "conf.bak")
              DeleteFile( prePath + "conf.bak" )
            EndIf
          EndIf
          ; ***
          reload_setup()
          ; ***
          CloseWindow(#fenster9)
        Case 965 ; Abbrechen
          CloseWindow(#fenster9)
      EndSelect
  EndSelect
EndProcedure

Procedure show_dlgAskLabel()
  If OpenWindow( #fenster3, 0, 0, 200, 90, "Bezeichner", #PB_Window_Invisible|#PB_Window_SystemMenu|#PB_Window_WindowCentered, WindowID(#fenster2) )
    ComboBoxGadget( #label_input, 10, 10, 180, 24, #PB_ComboBox_Editable )
    ButtonGadget( #label_ok, 100, 50, 90, 30, "Erstellen", #PB_Button_Default )
    ButtonGadget( #label_cancel, 10, 50, 90, 30, "Abbrechen" )
    ; ***
    AddGadgetItem( #label_input, -1, "Küche" )
    AddGadgetItem( #label_input, -1, "Wohnen" )
    AddGadgetItem( #label_input, -1, "Essen" )
    AddGadgetItem( #label_input, -1, "Schlafen" )
    AddGadgetItem( #label_input, -1, "Arbeiten" )
    AddGadgetItem( #label_input, -1, "Kind" )
    AddGadgetItem( #label_input, -1, "Hobby" )
    AddGadgetItem( #label_input, -1, "Abstellen" )
    AddGadgetItem( #label_input, -1, "Terrasse" )
    AddGadgetItem( #label_input, -1, "Loggia" )
    AddGadgetItem( #label_input, -1, "Balkon" )
    AddGadgetItem( #label_input, -1, "Garage" )
    AddGadgetItem( #label_input, -1, "Schuppen" )
    AddGadgetItem( #label_input, -1, "Werkstatt" )
    AddGadgetItem( #label_input, -1, "WC" )
    AddGadgetItem( #label_input, -1, "Gäste WC" )
    AddGadgetItem( #label_input, -1, "Bad" )
    AddGadgetItem( #label_input, -1, "Gäste" )
    AddGadgetItem( #label_input, -1, "Technik" )
    AddGadgetItem( #label_input, -1, "Hauswirtschaft" )
    AddGadgetItem( #label_input, -1, "Hausanschluss" )
    AddGadgetItem( #label_input, -1, "Keller" )
    AddGadgetItem( #label_input, -1, "Diele" )
    AddGadgetItem( #label_input, -1, "Flur" )
    AddGadgetItem( #label_input, -1, "Eingang" )
    AddGadgetItem( #label_input, -1, "Treppenhaus" )
    AddGadgetItem( #label_input, -1, "Offener Wohnraum" )
    AddGadgetItem( #label_input, -1, "Dachboden" )
    AddGadgetItem( #label_input, -1, "Spitzboden" )
    AddGadgetItem( #label_input, -1, "Carpot" )
    AddGadgetItem( #label_input, -1, "Gartenhaus" )
    AddGadgetItem( #label_input, -1, "Stahl" )
    AddGadgetItem( #label_input, -1, "Lager" )
    AddGadgetItem( #label_input, -1, "Geschäft" )
    AddGadgetItem( #label_input, -1, "Laden" )
    AddGadgetItem( #label_input, -1, "Arbeitszimmer" )
    AddGadgetItem( #label_input, -1, "Wohnzimmer" )
    AddGadgetItem( #label_input, -1, "Kinderzimmer" )
    AddGadgetItem( #label_input, -1, "Esszimmer" )
    AddGadgetItem( #label_input, -1, "Badezimmer" )
    AddGadgetItem( #label_input, -1, "WC, Bad" )
    AddGadgetItem( #label_input, -1, "WC" )
    AddGadgetItem( #label_input, -1, "Flur" )
    AddGadgetItem( #label_input, -1, "Stellraum" )
    AddGadgetItem( #label_input, -1, "Lagerraum" )
    AddGadgetItem( #label_input, -1, "Waschraum" )
    AddGadgetItem( #label_input, -1, "Salon" )
    AddGadgetItem( #label_input, -1, "WG-Zimmer" )
    AddGadgetItem( #label_input, -1, "Büroraum" )
    AddGadgetItem( #label_input, -1, "Technikraum" )
    AddGadgetItem( #label_input, -1, "Kühlraum" )
    AddGadgetItem( #label_input, -1, "Balkon" )
    AddGadgetItem( #label_input, -1, "Terasse" )
    AddGadgetItem( #label_input, -1, "Veranda" )
    ; ***
    AddKeyboardShortcut( #fenster3, #PB_Key_Return, #hk_enter )
    AddKeyboardShortcut( #fenster3, #PB_Key_Escape, #hk_escape )
    ; ***
    HideWindow(#fenster3,0)
  EndIf
EndProcedure

Procedure event_dlgAskLabel( evt.i )
  Protected p.w
  ; ***
  If Not IsWindow(#fenster3) : ProcedureReturn : EndIf
  If EventWindow() <> #fenster3 Or GetActiveWindow() <> #fenster3 : ProcedureReturn : EndIf
  ; ***
  Select evt
    Case #PB_Event_CloseWindow
      CloseWindow(#fenster3)
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #label_ok
          If add_item_to_draft() = 1
            For p = 0 To 80
              If IsGadget(#entry_shape + p)
                SetGadgetState( #entry_shape + p, 0 )
              EndIf
            Next
            ; ***
            CloseWindow(#fenster3)
          EndIf
        Case #label_cancel
          For p = 0 To 80
            If IsGadget(#entry_shape + p)
              SetGadgetState( #entry_shape + p, 0 )
            EndIf
          Next
          ; ***
          CloseWindow(#fenster3)
        Default
          For p = 0 To 80
            If IsGadget(#entry_shape + p)
              If EventGadget() <> draft_item
                SetGadgetState( #entry_shape + p, 0 )
              EndIf
            EndIf
          Next
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
        Case #hk_enter
          If add_item_to_draft() = 1
            For p = 0 To 80
              If IsGadget(#entry_shape + p)
                SetGadgetState( #entry_shape + p, 0 )
              EndIf
            Next
            ; ***
            CloseWindow(#fenster3)
          EndIf
        Case #hk_escape
          For p = 0 To 80
            If IsGadget(#entry_shape + p)
              SetGadgetState( #entry_shape + p, 0 )
            EndIf
          Next
          ; ***
          CloseWindow(#fenster3)
      EndSelect
  EndSelect
EndProcedure

Procedure show_dlgInputText()
  If OpenWindow( #fenster10, 0, 0, 300, 300, "Text einfügen", #PB_Window_Invisible|#PB_Window_SystemMenu|#PB_Window_WindowCentered, WindowID(#fenster2) )
    gui_window_icon( #fenster10, image_a(22) )
    ; ***
    EditorGadget( 990, 10, 10, 280, 240, #PB_Editor_WordWrap )
    ; ***
    If IsFont(800)
      SetGadgetFont(990,FontID(800))
    EndIf
    ; ***
    ButtonGadget( 991, WindowWidth(#fenster10) - 110, WindowHeight(#fenster10) - 40, 100, 30, "Erstellen" )
    ; ***
    ButtonGadget( 992, WindowWidth(#fenster10) - 220, WindowHeight(#fenster10) - 40, 100, 30, "Abbrechen" )
    ; ***
    AddKeyboardShortcut( #fenster10, #PB_Key_Escape, #hk_escape )
    ; ***
    HideWindow(#fenster10,0)
  EndIf
EndProcedure

Procedure event_dlgInputText( evt.i )
  Protected p.w, pth.s
  ; ***
  If Not IsWindow(#fenster10) : ProcedureReturn : EndIf
  If EventWindow() <> #fenster10 Or GetActiveWindow() <> #fenster10 : ProcedureReturn : EndIf
  ; ***
  Select evt
    Case #PB_Event_CloseWindow
      CloseWindow(#fenster10)
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 991
          If Trim(GetGadgetText(990))
            gvmr\temptext = GetGadgetText(990)
            ; ***
            add_item_to_draft()
            ; ***
            CloseWindow(#fenster10)
          EndIf
        Case 992
          CloseWindow(#fenster10)
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
        Case #hk_escape
          CloseWindow(#fenster10)
      EndSelect
  EndSelect
EndProcedure

Procedure show_newAdd()
  If OpenWindow( #fenster5, 0, 0, 440, 440, "Neuer Entwurf", #PB_Window_Invisible|#PB_Window_SystemMenu|#PB_Window_WindowCentered, WindowID(#fenster2) )
    gui_window_icon( #fenster5, 955 )
    ; ***
    TextGadget( 600, 10, 10, 420, 30, "Um welches Geschoss handelt es sich?", #PB_Text_Center )
    ; ***
    ListViewGadget( 700, 10, 40, 420, 80 )
    ; ***
    AddGadgetItem( 700, -1, "Untergeschoss" )
    AddGadgetItem( 700, -1, "Erdgeschoss" )
    AddGadgetItem( 700, -1, "1. Obergeschoss" )
    AddGadgetItem( 700, -1, "2. Obergeschoss" )
    AddGadgetItem( 700, -1, "3. Obergeschoss" )
    AddGadgetItem( 700, -1, "4. Obergeschoss" )
    AddGadgetItem( 700, -1, "5. Obergeschoss" )
    AddGadgetItem( 700, -1, "6. Obergeschoss" )
    AddGadgetItem( 700, -1, "7. Obergeschoss" )
    AddGadgetItem( 700, -1, "8. Obergeschoss" )
    AddGadgetItem( 700, -1, "9. Obergeschoss" )
    AddGadgetItem( 700, -1, "10. Obergeschoss" )
    AddGadgetItem( 700, -1, "11. Obergeschoss" )
    AddGadgetItem( 700, -1, "12. Obergeschoss" )
    AddGadgetItem( 700, -1, "13. Obergeschoss" )
    AddGadgetItem( 700, -1, "14. Obergeschoss" )
    AddGadgetItem( 700, -1, "Dachgeschoss" )
    AddGadgetItem( 700, -1, "Spitzboden" )
    SetGadgetState( 700, 0 )
    ; ***
    CheckBoxGadget( 701, 10, GadgetY(700) + GadgetHeight(700) + 10, 420, 30, "Gibt es separierte Einheiten?" )
    ; ***
    TextGadget( 601, 10, GadgetY(701) + GadgetHeight(701) + 10, 420, 30, "Wenn ja, um welche Einheit handelt es sich?", #PB_Text_Center )
    ; ***
    ListViewGadget( 702, 10, GadgetY(601) + GadgetHeight(601), 420, 80 )
    ; ***
    DisableGadget( 702, 1 )
    ; ***
    AddGadgetItem( 702, -1, "Wohneinheit 1" )
    AddGadgetItem( 702, -1, "Wohneinheit 2" )
    AddGadgetItem( 702, -1, "Wohneinheit 3" )
    AddGadgetItem( 702, -1, "Wohneinheit 4" )
    AddGadgetItem( 702, -1, "Wohneinheit 5" )
    AddGadgetItem( 702, -1, "Wohneinheit 6" )
    AddGadgetItem( 702, -1, "Wohneinheit 7" )
    AddGadgetItem( 702, -1, "Wohneinheit 8" )
    AddGadgetItem( 702, -1, "Wohneinheit 9" )
    AddGadgetItem( 702, -1, "Wohneinheit 10" )
    AddGadgetItem( 702, -1, "Wohneinheit 11" )
    AddGadgetItem( 702, -1, "Wohneinheit 12" )
    SetGadgetState( 702, 0 )
    ; ***
    CheckBoxGadget( 703, 10, GadgetY(702) + GadgetHeight(702) + 10, 420, 30, "Handelt es sich um eine Einliegerwohnung?", #PB_Text_Center )
    ; ***
    ListViewGadget( 704, 10, GadgetY(703) + GadgetHeight(703), 420, 70 )
    ; ***
    DisableGadget( 704, 1 )
    ; ***
    AddGadgetItem( 704, -1, "Ja" )
    AddGadgetItem( 704, -1, "Nein" )
    AddGadgetItem( 704, -1, "Kein Info" )
    SetGadgetState( 704, 0 )
    ; ***
    ButtonGadget( 705, WindowWidth(#fenster5) - 110, WindowHeight(#fenster5) - 40, 100, 30, "Erstellen" )
    ; ***
    ButtonGadget( 706, WindowWidth(#fenster5) - 220, WindowHeight(#fenster5) - 40, 100, 30, "Abbrechen" )
    ; ***
    HideWindow(#fenster5,0)
  EndIf
EndProcedure

Procedure event_newAdd( evt.i )
  Protected a.s = "", b.a = 0, c.s = ""
  ; ***
  If Not IsWindow(#fenster5) : ProcedureReturn : EndIf
  If EventWindow() <> #fenster5 Or GetActiveWindow() <> #fenster5 : ProcedureReturn : EndIf
  ; ***
  Select evt
    Case #PB_Event_CloseWindow
      CloseWindow(#fenster5)
    Case #PB_Event_Gadget
      Select EventGadget()
        Case 701
          Select GetGadgetState(EventGadget())
            Case 0 : DisableGadget( 702, 1 )
            Case 1 : DisableGadget( 702, 0 )
          EndSelect
        Case 703
          Select GetGadgetState(EventGadget())
            Case 0 : DisableGadget( 704, 1 )
            Case 1 : DisableGadget( 704, 0 )
          EndSelect
        Case 705
          If GetGadgetState(701) = 1
            a = GetGadgetText(702)
          EndIf
          ; ***
          If GetGadgetState(703) = 1
            b = GetGadgetState(704) + 1
            ; ***
            Select b
              Case 1 : c = "Ja"
              Case 2 : c = "Nein"
              Case 3 : c = ""
            EndSelect
          EndIf
          ; ***
          add_new_object_unit( gvmo, GetGadgetText(700), GetGadgetState(701), a, b )
          ; ***
          AddGadgetItem( #canvas4, -1, "[" + Str(CountGadgetItems(#canvas4) + 1) + "] " + GetGadgetText(700) + Chr(10) + a + Chr(10) + c )
          ; ***
          If CountGadgetItems(#canvas4) > 0
            SetGadgetState( #canvas4, CountGadgetItems(#canvas4) - 1 )
          EndIf
          ; ***
          CloseWindow(#fenster5)
        Case 706
          CloseWindow(#fenster5)
      EndSelect
  EndSelect
EndProcedure

Procedure resize_dlgMain()
;  ResizeGadget( #canvas1, 0, 0, WindowWidth(#fenster2), ToolBarHeight(10) )
  ; ***
  ResizeGadget( #panelmn, 0, ToolBarHeight(10), WindowWidth(#fenster2) - 180, WindowHeight(#fenster2) - ToolBarHeight(10) - 40 - StatusBarHeight(20) )
  ; ***
  ResizeGadget( #panelsd, WindowWidth(#fenster2) - 180, ToolBarHeight(10), 180, WindowHeight(#fenster2) - ToolBarHeight(10) - 40 - 100 - StatusBarHeight(20) )
  ; ***
  ResizeGadget( #canvas4, WindowWidth(#fenster2) - 180, GadgetY(#panelsd) + GadgetHeight(#panelsd), 180, 100 )
  ; ***
  ResizeGadget( #radio_1, 10,  WindowHeight(#fenster2) - 30 - StatusBarHeight(20), 120, 30 )
  ResizeGadget( #radio_2, 130, WindowHeight(#fenster2) - 30 - StatusBarHeight(20), 120, 30 )
  ResizeGadget( #radio_3, 250, WindowHeight(#fenster2) - 30 - StatusBarHeight(20), 120, 30 )
  ResizeGadget( #radio_4, 380, WindowHeight(#fenster2) - 30 - StatusBarHeight(20), 120, 30 )
  ; ***
;  ResizeGadget( #zoom_track, WindowWidth(#fenster2) - GadgetWidth(#zoom_track) - 10, GadgetY(#radio_1), 100, 30 )
;  ResizeGadget( #zoom_label, GadgetX(#zoom_track) - GadgetWidth(#zoom_label), GadgetY(#zoom_track), 90, 30 )
  ; ***
  draw_visual_measure_render( gvmr )
EndProcedure

Procedure show_dlgMain()
  Protected p.w, a.w = 0, n.w = 0
  ; ***6
  If OpenWindow( #fenster2, 0, 0, 800, 460, "MeasureIt", #PB_Window_Invisible|#PB_Window_SystemMenu|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget|#PB_Window_SizeGadget|#PB_Window_ScreenCentered )
    window_counter + 1
    ; ***
    AddWindowTimer( #fenster2, 1780, 150 )
    ; ***
    If CreateToolBar( 10, WindowID(#fenster2), #PB_ToolBar_Small|#PB_ToolBar_Text )
      ToolBarImageButton( 2000, ImageID(953), #PB_ToolBar_Normal, "Objekt laden" )
      ToolBarImageButton( 2001, ImageID(954), #PB_ToolBar_Normal, "Speichern" )
      ToolBarSeparator()
      ToolBarImageButton( 2011, ImageID(961), #PB_ToolBar_Normal, "Export" )
      ToolBarSeparator()
      ToolBarImageButton( 2002, ImageID(950), #PB_ToolBar_Normal, "Neues Objekt" )
      ToolBarImageButton( 2003, ImageID(951), #PB_ToolBar_Normal, "Wechseln" )
      ToolBarImageButton( 2004, ImageID(952), #PB_ToolBar_Normal, "Löschen" )
      ToolBarSeparator()
      ToolBarImageButton( 2005, ImageID(955), #PB_ToolBar_Normal, "Neuer Entwurf" )
      ToolBarImageButton( 2006, ImageID(960), #PB_ToolBar_Normal, "Löschen" )
      ToolBarSeparator()
;      ToolBarImageButton( 2012, ImageID(image_a(99)), #PB_ToolBar_Toggle, "Pixel" )
;      ToolBarSeparator()
      ToolBarImageButton( 2007, ImageID(957), #PB_ToolBar_Normal, "Element bearbeiten" )
      ToolBarImageButton( 2008, ImageID(956), #PB_ToolBar_Normal, "Löschen" )
      ToolBarSeparator()
      ToolBarImageButton( 2009, ImageID(958), #PB_ToolBar_Normal, "Senden" )
      ToolBarSeparator()
      ToolBarImageButton( 2010, ImageID(959), #PB_ToolBar_Normal, "Einstellungen" )
      ; ***
      ToolBarToolTip( 10, 2000, "Objekt aus Datei laden" )
      ToolBarToolTip( 10, 2001, "Objekt speichern" )
      ToolBarToolTip( 10, 2002, "Neues Objekt anlegen" )
      ToolBarToolTip( 10, 2003, "Objekt wechseln" )
      ToolBarToolTip( 10, 2004, "Aktuelles Objekt löschen" )
      ToolBarToolTip( 10, 2005, "Neuen Entwurf zum Objekt hinzufügen" )
      ToolBarToolTip( 10, 2006, "Aktuellen Entwurf löschen" )
      ToolBarToolTip( 10, 2007, "Markiertes Element bearbeiten" )
      ToolBarToolTip( 10, 2008, "Markiertes Element löschen" )
      ToolBarToolTip( 10, 2009, "Daten an den Server senden" )
      ToolBarToolTip( 10, 2010, "Programmeinstellungen" )
      ToolBarToolTip( 10, 2011, "Entwurf als Grafik speichern" )
;      ToolBarToolTip( 10, 2012, "Elemen pixelgenau zeichnen" )
    EndIf
    ; ***
    If CreateStatusBar( 20, WindowID(#fenster2) )
      AddStatusBarField( #PB_Ignore )
      AddStatusBarField( #PB_Ignore )
      AddStatusBarField( #PB_Ignore )
      AddStatusBarField( #PB_Ignore )
      AddStatusBarField( #PB_Ignore )
      AddStatusBarField( #PB_Ignore )
    EndIf
    ; ***
    If ScrollAreaGadget( #panelmn, 0, 0, 200, 200, 2048, 2048, 10, #PB_ScrollArea_BorderLess )
      CanvasGadget( #canvas2, 0, 0, 2048, 2048, #PB_Canvas_Keyboard )
      ; ***
      CloseGadgetList()
    EndIf
    ; ***
    If ScrollAreaGadget( #panelsd, 0, 0, 200, 200, 180, 870, 10, #PB_ScrollArea_BorderLess )
      ComboBoxGadget( #combo_shape_selector, 0, 0, 160, 24 )
      ; ***
      AddGadgetItem( #combo_shape_selector, -1, "Raum" )
      AddGadgetItem( #combo_shape_selector, -1, "Fenster" )
      AddGadgetItem( #combo_shape_selector, -1, "Treppe" )
      AddGadgetItem( #combo_shape_selector, -1, "Tür" )
      AddGadgetItem( #combo_shape_selector, -1, "Pfeil" )
      AddGadgetItem( #combo_shape_selector, -1, "Text & Marker" )
      AddGadgetItem( #combo_shape_selector, -1, "Aufzug" )
      AddGadgetItem( #combo_shape_selector, -1, "Stütze" )
      AddGadgetItem( #combo_shape_selector, -1, "Kamin" )
      AddGadgetItem( #combo_shape_selector, -1, "Dach" )
      ; ***
      SetGadgetState( #combo_shape_selector, 0 )
      ; ***
      If ContainerGadget( #panelb1, 0, 24, 160, 440, #PB_Container_BorderLess )
        n = 0 : a = 0
        ; ***
        For p = 0 To 21
          Select a
            Case 0
              If IsImage( image_a(p) ) > 0
                ButtonImageGadget( #entry_shape + p, 0, n, 52, 52, ImageID( image_a(p) ), #PB_Button_Toggle )
              EndIf
              ; ***
              a = 1
            Case 1
              If IsImage( image_a(p) ) > 0
                ButtonImageGadget( #entry_shape + p, 52, n, 52, 52, ImageID( image_a(p) ), #PB_Button_Toggle )
              EndIf
              ; ***
              a = 2
            Case 2
              If IsImage( image_a(p) ) > 0
                ButtonImageGadget( #entry_shape + p, 52 * 2, n, 52, 52, ImageID( image_a(p) ), #PB_Button_Toggle )
              EndIf
              ; ***
              a = 0
              ; ***
              n + 52
          EndSelect
        Next
        ; ***
        CloseGadgetList()
      EndIf
      ; ***
      If ContainerGadget( #panelb2, 0, 24, 160, 100, #PB_Container_BorderLess )
        If IsImage( image_a(76) ) > 0
          ButtonImageGadget( #entry_shape + 22, 0, 0, 52, 52, ImageID( image_a(76) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(77) ) > 0
          ButtonImageGadget( #entry_shape + 23, 52, 0, 52, 52, ImageID( image_a(77) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(90) ) > 0
          ButtonImageGadget( #entry_shape + 24, 52 * 2, 0, 52, 52, ImageID( image_a(90) ), #PB_Button_Toggle )
        EndIf
        ; ***
        CloseGadgetList()
        ; ***
        HideGadget( #panelb2, 1 )
      EndIf
      ; ***
      If ContainerGadget( #panelb3, 0, 24, 160, 840, #PB_Container_BorderLess )
        n = 0 : a = 0
        ; ***
        For p = 25 To 69 + 3
          Select a
            Case 0
              If IsImage( image_a(p + 3) ) > 0
                ButtonImageGadget( #entry_shape + p, 0, n, 52, 52, ImageID( image_a(p + 3) ), #PB_Button_Toggle )
              EndIf
              ; ***
              a = 1
            Case 1
              If IsImage( image_a(p + 3) ) > 0
                ButtonImageGadget( #entry_shape + p, 52, n, 52, 52, ImageID( image_a(p + 3) ), #PB_Button_Toggle )
              EndIf
              ; ***
              a = 2
            Case 2
              If IsImage( image_a(p + 3) ) > 0
                ButtonImageGadget( #entry_shape + p, 52 * 2, n, 52, 52, ImageID( image_a(p + 3) ), #PB_Button_Toggle )
              EndIf              
              ; ***
              a = 0
              ; ***
              n + 52
          EndSelect
        Next
        ; ***
        CloseGadgetList()
        ; ***
        HideGadget( #panelb3, 1 )
      EndIf
      ; ***
      If ContainerGadget( #panelb4, 0, 24, 160, 330, #PB_Container_BorderLess )
        If IsImage( image_a(78) ) > 0
          ButtonImageGadget( #entry_shape + 70 + 4, 0, 0, 52, 52, ImageID( image_a(78) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(79) ) > 0
          ButtonImageGadget( #entry_shape + 71 + 4, 52, 0, 52, 52, ImageID( image_a(79) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(80) ) > 0
          ButtonImageGadget( #entry_shape + 72 + 4, 52 * 2, 0, 52, 52, ImageID( image_a(80) ), #PB_Button_Toggle )
        EndIf
        ; --------------------------------------------------
        ; ***
        If IsImage( image_a(81) ) > 0
          ButtonImageGadget( #entry_shape + 73 + 4, 0, 52, 52, 52, ImageID( image_a(81) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(82) ) > 0
          ButtonImageGadget( #entry_shape + 74 + 4, 52, 52, 52, 52, ImageID( image_a(82) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(83) ) > 0
          ButtonImageGadget( #entry_shape + 75 + 4, 52 * 2, 52, 52, 52, ImageID( image_a(83) ), #PB_Button_Toggle )
        EndIf
        ; --------------------------------------------------
        ; ***
        If IsImage( image_a(84) ) > 0
          ButtonImageGadget( #entry_shape + 76 + 4, 0, 52 * 2, 52, 52, ImageID( image_a(84) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(85) ) > 0
          ButtonImageGadget( #entry_shape + 77 + 4, 52, 52 * 2, 52, 52, ImageID( image_a(85) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(86) ) > 0
          ButtonImageGadget( #entry_shape + 78 + 4, 52 * 2, 52 * 2, 52, 52, ImageID( image_a(86) ), #PB_Button_Toggle )
        EndIf
        ; --------------------------------------------------
        ; ***
        If IsImage( image_a(87) ) > 0
          ButtonImageGadget( #entry_shape + 79 + 4, 0, 52 * 3, 52, 52, ImageID( image_a(87) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(88) ) > 0
          ButtonImageGadget( #entry_shape + 80 + 4, 52, 52 * 3, 52, 52, ImageID( image_a(88) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(89) ) > 0
          ButtonImageGadget( #entry_shape + 81 + 4, 52 * 2, 52 * 3, 52, 52, ImageID( image_a(89) ), #PB_Button_Toggle )
        EndIf
        ; ***
        CloseGadgetList()
        ; ***
        HideGadget( #panelb4, 1 )
      EndIf
      ; ***
      If ContainerGadget( #panelb5, 0, 24, 160, 130, #PB_Container_BorderLess )
        If IsImage( image_a(25) ) > 0
          ButtonImageGadget( #entry_shape + 90 + 4, 0, 0, 52, 52, ImageID( image_a(25) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(26) ) > 0
          ButtonImageGadget( #entry_shape + 91 + 4, 52, 0, 52, 52, ImageID( image_a(26) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(27) ) > 0
          ButtonImageGadget( #entry_shape + 92 + 4, 52 * 2, 0, 52, 52, ImageID( image_a(27) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(91) ) > 0
          ButtonImageGadget( #entry_shape + 93 + 4, 0, 52, 52, 52, ImageID( image_a(91) ), #PB_Button_Toggle )
        EndIf
        ; ***
        CloseGadgetList()
        ; ***
        HideGadget( #panelb5, 1 )
      EndIf
      ; ***
      If ContainerGadget( #panelb6, 0, 24, 160, 100, #PB_Container_BorderLess )
        If IsImage( image_a(22) ) > 0
          ButtonImageGadget( #entry_shape + 94 + 5, 0, 0, 52, 52, ImageID( image_a(22) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(23) ) > 0
          ButtonImageGadget( #entry_shape + 95 + 5, 52, 0, 52, 52, ImageID( image_a(23) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(24) ) > 0
          ButtonImageGadget( #entry_shape + 96 + 5, 52 * 2, 0, 52, 52, ImageID( image_a(24) ), #PB_Button_Toggle )
        EndIf
        ; ***
        CloseGadgetList()
        ; ***
        HideGadget( #panelb6, 1 )
      EndIf
      ; ***
      If ContainerGadget( #panelb7, 0, 24, 160, 120, #PB_Container_BorderLess )
        If IsImage( image_a(92) ) > 0
          ButtonImageGadget( #entry_shape + 97 + 6, 0, 0, 52, 52, ImageID( image_a(92) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(93) ) > 0
          ButtonImageGadget( #entry_shape + 98 + 6, 52, 0, 52, 52, ImageID( image_a(93) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(94) ) > 0
          ButtonImageGadget( #entry_shape + 99 + 6, 52 * 2, 0, 52, 52, ImageID( image_a(94) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(95) ) > 0
          ButtonImageGadget( #entry_shape + 100 + 6, 0, 52, 52, 52, ImageID( image_a(95) ), #PB_Button_Toggle )
        EndIf
        ; ***
        CloseGadgetList()
        ; ***
        HideGadget( #panelb7, 1 )
      EndIf
      ; ***
      If ContainerGadget( #panelb8, 0, 24, 160, 120, #PB_Container_BorderLess )
        If IsImage( image_a(96) ) > 0
          ButtonImageGadget( #entry_shape + 101 + 7, 0, 0, 52, 52, ImageID( image_a(96) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(97) ) > 0
          ButtonImageGadget( #entry_shape + 102 + 7, 52, 0, 52, 52, ImageID( image_a(97) ), #PB_Button_Toggle )
        EndIf
        ; ***
        CloseGadgetList()
        ; ***
        HideGadget( #panelb8, 1 )
      EndIf
      ; ***
      If ContainerGadget( #panelb9, 0, 24, 160, 120, #PB_Container_BorderLess )
        If IsImage( image_a(98) ) > 0
          ButtonImageGadget( #entry_shape + 103 + 8, 0, 0, 52, 52, ImageID( image_a(98) ), #PB_Button_Toggle )
        EndIf
        ; ***
        CloseGadgetList()
        ; ***
        HideGadget( #panelb9, 1 )
      EndIf
      ; ***
      If ContainerGadget( #panelb10, 0, 24, 160, 120, #PB_Container_BorderLess )
        If IsImage( image_a(100) ) > 0
          ButtonImageGadget( #entry_shape + 104 + 8, 0, 0, 52, 52, ImageID( image_a(100) ), #PB_Button_Toggle )
        EndIf
        ; ***
        If IsImage( image_a(101) ) > 0
          ButtonImageGadget( #entry_shape + 105 + 8, 52, 0, 52, 52, ImageID( image_a(101) ), #PB_Button_Toggle )
        EndIf
        ; ***
        CloseGadgetList()
        ; ***
        HideGadget( #panelb10, 1 )
      EndIf
      ; ***
      CloseGadgetList()
    EndIf
    ; ***
    ListIconGadget( #canvas4, 0, 0, 180, 100, "Geschoss", 150, #PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect )
    AddGadgetColumn( #canvas4, 2, "Einheit", 150 )
    AddGadgetColumn( #canvas4, 3, "ELGW", 90 )
    ; ***
    OptionGadget( #radio_1, 0, 0, 120, 30, "Entwurf" )
    OptionGadget( #radio_2, 0, 0, 120, 30, "Ansicht 2" )
    OptionGadget( #radio_3, 0, 0, 120, 30, "Ansicht 3" )
    OptionGadget( #radio_4, 0, 0, 120, 30, "Klarsicht" )
;    TextGadget( #zoom_label, 0, 0, 100, 30, "Zoom: ", #PB_Text_Right )
;    TrackBarGadget( #zoom_track, 0, 0, 100, 30, 0, 9, #PB_TrackBar_Ticks )
    ; ***
    SetGadgetState( #radio_1, 1 )
    ; ***
    AddKeyboardShortcut( #fenster2, #PB_Key_Escape, #hk_escape )
    ; ***
    BindEvent( #PB_Event_SizeWindow, @resize_dlgMain() )
    BindEvent( #PB_Event_MaximizeWindow, @resize_dlgMain() )
    BindEvent( #PB_Event_RestoreWindow, @resize_dlgMain() )
    ; ***
    resize_dlgMain()
    ; ***
    draw_visual_measure_render( gvmr )
    ; ***
    HideWindow( #fenster2, 0 )
    ; ***
    show_dlgObjekt()
  EndIf
EndProcedure

Procedure event_dlgMain( evt.i )
  If Not IsWindow(#fenster2) : ProcedureReturn : EndIf
  If EventWindow() <> #fenster2 Or GetActiveWindow() <> #fenster2 : ProcedureReturn : EndIf
  ; ***
  Protected p.w, pth.s
  ; ***
  Select evt
    Case #PB_Event_CloseWindow
      If MessageRequester("MeasureIT", "Programm beenden?", #PB_MessageRequester_YesNo ) = #PB_MessageRequester_Yes
        CloseWindow(#fenster2)
        ; ***
        End
      EndIf
    Case #PB_Event_Timer
      If EventTimer() = 1780
        gvmr\measurevalue = setup_meas + 1
      EndIf
    Case #PB_Event_Menu
      Select EventMenu()
        Case 2000 ; Objekt laden
          show_dlgOpen()
        Case 2001 ; Objekt speichern
          If gvmo\path = ""
            err_ask(2)
          Else
            set_visual_measure_render_view( gvmo, gvmr )
            ; ***
            save_to_file( gvmo )
          EndIf
        Case 2002 ; Neues Objekt
          show_dlgObjekt()
        Case 2003 ; Objekt Wechseln
          If gvmo\path = ""
            show_dlgOpen()
          Else
            show_dlgSwichtObject()
          EndIf
        Case 2004 ; Objekt löschen
          If ListSize(gvmo\items()) > 0
            If MessageRequester( "Objekt löschen", "Soll der aktuelle Objekt gelöscht werden?", #PB_MessageRequester_YesNo ) = #PB_MessageRequester_Yes
              remove_current_object()
            EndIf
          Else
            err_ask(2)
          EndIf
        Case 2005 ; neuer Entwurf
          If gvmo\path <> ""
            show_newAdd()
          Else
            err_ask(2)
          EndIf
        Case 2006 ; Entwurf löschen
          If ListSize(gvmr\items()) > 0
            remove_current_visual_measure_render( gvmo, gvmr )
          Else
            err_ask(1)
          EndIf
        Case 2007 ; Element bearbeiten
          If ListSize(gvmr\items()) > 0
            show_dlgEdit()
          Else
            err_ask(1)
          EndIf
        Case 2008 ; Element löschen
          If ListSize(gvmr\items()) > 0
            If MessageRequester( "Element löschen", "Soll das aktuelle Element gelöscht werden?", #PB_MessageRequester_YesNo ) = #PB_MessageRequester_Yes
              remove_visual_measure_render_item( gvmr )
            EndIf
          Else
            err_ask(1)
          EndIf
        Case 2009 ; Daten senden
          If ListSize(gvmo\items()) > 0
            If setup_user And setup_pass And setup_path
              show_send()
            Else
              MessageRequester( "Abbruch", "Um daten an den Server senden zu können, muss eine Internetverbindung bestehen und die Serverdaten müssen unter 'Einstellungen' angegeben werden!", #PB_MessageRequester_Info )
            EndIf
          Else
            err_ask(2)
          EndIf
        Case 2010 ; Einstellungen
          show_dlgSetup()
        Case 2011 ; Export
          If ListSize(gvmo\items()) > 0
            show_export()
          Else
            err_ask(2)
          EndIf
        Case 2012 ; Pixelgenau zeichnen
          If ListSize(gvmo\items()) > 0
            If ListSize(gvmr\items()) > 0
              gvmr\pixelresize = GetToolBarButtonState( 10, 2012 )
            Else
              SetToolBarButtonState( 10, 2012, 0 )
              ; ***
              err_ask(1)
            EndIf
          Else
            SetToolBarButtonState( 10, 2012, 0 )
            ; ***
            err_ask(2)
          EndIf
        Case 2101 ; Fenster -> Hinzufügen -> 0,3 x 0,5
          element_w = 0.5 * 12
          element_h = 0.3 * 6
          add_item_to_draft()
      EndSelect
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #zoom_track
          gvmr\zoom = GetGadgetState(#zoom_track)
          ; ***
          draw_visual_measure_render( gvmr )
        Case #combo_shape_selector
          Select GetGadgetState(#combo_shape_selector)
            Case 0
              HideGadget( #panelb1, 0 )
              HideGadget( #panelb2, 1 )
              HideGadget( #panelb3, 1 )
              HideGadget( #panelb4, 1 )
              HideGadget( #panelb5, 1 )
              HideGadget( #panelb6, 1 )
              HideGadget( #panelb7, 1 )
              HideGadget( #panelb8, 1 )
              HideGadget( #panelb9, 1 )
              HideGadget( #panelb10, 1 )
            Case 1
              HideGadget( #panelb1, 1 )
              HideGadget( #panelb2, 0 )
              HideGadget( #panelb3, 1 )
              HideGadget( #panelb4, 1 )
              HideGadget( #panelb5, 1 )
              HideGadget( #panelb6, 1 )
              HideGadget( #panelb7, 1 )
              HideGadget( #panelb8, 1 )
              HideGadget( #panelb9, 1 )
              HideGadget( #panelb10, 1 )
            Case 2
              HideGadget( #panelb1, 1 )
              HideGadget( #panelb2, 1 )
              HideGadget( #panelb3, 0 )
              HideGadget( #panelb4, 1 )
              HideGadget( #panelb5, 1 )
              HideGadget( #panelb6, 1 )
              HideGadget( #panelb7, 1 )
              HideGadget( #panelb8, 1 )
              HideGadget( #panelb9, 1 )
              HideGadget( #panelb10, 1 )
            Case 3
              HideGadget( #panelb1, 1 )
              HideGadget( #panelb2, 1 )
              HideGadget( #panelb3, 1 )
              HideGadget( #panelb4, 0 )
              HideGadget( #panelb5, 1 )
              HideGadget( #panelb6, 1 )
              HideGadget( #panelb7, 1 )
              HideGadget( #panelb8, 1 )
              HideGadget( #panelb9, 1 )
              HideGadget( #panelb10, 1 )
            Case 4
              HideGadget( #panelb1, 1 )
              HideGadget( #panelb2, 1 )
              HideGadget( #panelb3, 1 )
              HideGadget( #panelb4, 1 )
              HideGadget( #panelb5, 0 )
              HideGadget( #panelb6, 1 )
              HideGadget( #panelb7, 1 )
              HideGadget( #panelb8, 1 )
              HideGadget( #panelb9, 1 )
              HideGadget( #panelb10, 1 )
            Case 5
              HideGadget( #panelb1, 1 )
              HideGadget( #panelb2, 1 )
              HideGadget( #panelb3, 1 )
              HideGadget( #panelb4, 1 )
              HideGadget( #panelb5, 1 )
              HideGadget( #panelb6, 0 )
              HideGadget( #panelb7, 1 )
              HideGadget( #panelb8, 1 )
              HideGadget( #panelb9, 1 )
              HideGadget( #panelb10, 1 )
            Case 6
              HideGadget( #panelb1, 1 )
              HideGadget( #panelb2, 1 )
              HideGadget( #panelb3, 1 )
              HideGadget( #panelb4, 1 )
              HideGadget( #panelb5, 1 )
              HideGadget( #panelb6, 1 )
              HideGadget( #panelb7, 0 )
              HideGadget( #panelb8, 1 )
              HideGadget( #panelb9, 1 )
              HideGadget( #panelb10, 1 )
            Case 7
              HideGadget( #panelb1, 1 )
              HideGadget( #panelb2, 1 )
              HideGadget( #panelb3, 1 )
              HideGadget( #panelb4, 1 )
              HideGadget( #panelb5, 1 )
              HideGadget( #panelb6, 1 )
              HideGadget( #panelb7, 1 )
              HideGadget( #panelb8, 0 )
              HideGadget( #panelb9, 1 )
              HideGadget( #panelb10, 1 )
            Case 8
              HideGadget( #panelb1, 1 )
              HideGadget( #panelb2, 1 )
              HideGadget( #panelb3, 1 )
              HideGadget( #panelb4, 1 )
              HideGadget( #panelb5, 1 )
              HideGadget( #panelb6, 1 )
              HideGadget( #panelb7, 1 )
              HideGadget( #panelb8, 1 )
              HideGadget( #panelb9, 0 )
              HideGadget( #panelb10, 1 )
            Case 9
              HideGadget( #panelb1, 1 )
              HideGadget( #panelb2, 1 )
              HideGadget( #panelb3, 1 )
              HideGadget( #panelb4, 1 )
              HideGadget( #panelb5, 1 )
              HideGadget( #panelb6, 1 )
              HideGadget( #panelb7, 1 )
              HideGadget( #panelb8, 1 )
              HideGadget( #panelb9, 1 )
              HideGadget( #panelb10, 0 )
          EndSelect
        Case #canvas2
          If CountGadgetItems(#canvas4) = 0
            Select EventType()
              Case #PB_EventType_LeftButtonDown, #PB_EventType_RightButtonDown
                err_ask(0)
            EndSelect
          Else
            event_visual_measure_render( gvmr, evt )
            ; ***
            StatusBarText( 20, 5, Str(gvmr\px) + " x " + Str(gvmr\py) )
          EndIf
        Case #canvas4
          If CountGadgetItems(#canvas4) = 0
            Select EventType()
              Case #PB_EventType_Change, #PB_EventType_LeftClick ;#PB_EventType_LeftButtonDown, #PB_EventType_RightButtonDown
                err_ask(0)
              Case #PB_EventType_RightClick
                If CountGadgetItems(#canvas4) > 0 And GetGadgetText(#canvas4) And GetGadgetState(#canvas4) >= 0
                  DisplayPopupMenu( 903, WindowID(#fenster2) )
                EndIf
            EndSelect
          Else
            If Trim(GetGadgetText(#canvas4)) And CountGadgetItems(#canvas4) > 0 And GetGadgetState(#canvas4) >= 0
              switch_visual_measure_render_view( gvmo, gvmr, GetGadgetState(#canvas4) )
              ; ***
              StatusBarText( 20, 4, "Entwurf " + Str( GetGadgetState(#canvas4) + 1) )
            EndIf
          EndIf
        Case #radio_1
          If CountGadgetItems(#canvas4) = 0
            err_ask(0)
          Else
            gvmr\viewmode = 0 : draw_visual_measure_render( gvmr )
          EndIf
        Case #radio_2
          If CountGadgetItems(#canvas4) = 0
            err_ask(0)
          Else
            gvmr\viewmode = 1 : draw_visual_measure_render( gvmr )
          EndIf
        Case #radio_3
          If CountGadgetItems(#canvas4) = 0
            err_ask(0)
          Else
            gvmr\viewmode = 2 : draw_visual_measure_render( gvmr )
          EndIf
        Case #radio_4
          If CountGadgetItems(#canvas4) = 0
            err_ask(0)
          Else
            gvmr\viewmode = 3 : draw_visual_measure_render( gvmr )
          EndIf
        Default
          For p = 0 To 199
            If EventGadget() = #entry_shape + p
              If CountGadgetItems(#canvas4) = 0
                err_ask(0)
              Else
                draft_item = #entry_shape + p
                ; ***
;Debug Str(draft_item)
                Select draft_item
                  Case 55 To 76
                    show_dlgAskLabel()
                  Case 157 ; Text
                    show_dlgInputText()
                  Case 158 ; Zähler
                    gvmr\numbering[0] + 1
                    ; ***
                    add_item_to_draft()
                  Case 159 ; Zähler
                    gvmr\numbering[1] + 1
                    ; ***
                    add_item_to_draft()
                  ;Case 83 ; Fenster V
                  ;  fenster_element_typ = 1
                  ;  If IsMenu(904)
                  ;    DisplayPopupMenu(904,WindowID(#fenster2))
                  ;  EndIf
                  ;Case 84 ; Fenster H
                  ;  fenster_element_typ = 2
                  ;  If IsMenu(905)
                  ;    DisplayPopupMenu(905,WindowID(#fenster2))
                  ;  EndIf
                  ;Case 85 ; Fenster Doppelt
                  ;  fenster_element_typ = 3
                  ;  If IsMenu(906)
                  ;    DisplayPopupMenu(906,WindowID(#fenster2))
                  ;  EndIf
                  Default
                    add_item_to_draft()
                EndSelect
              EndIf
              ; ***
              Break
            EndIf
          Next
      EndSelect
  EndSelect
EndProcedure

Procedure menu_dlgMain( key.s )
  
EndProcedure

Procedure show_dlgLogin()
  If OpenWindow( #fenster1, 0, 0, 400, 150, "MeasureIt - Login", #PB_Window_SystemMenu|#PB_Window_ScreenCentered )
    window_counter + 1
    ; ***
    TextGadget( #login_label_1, 20, 20, 180, 30, "Benutzer:" )
    StringGadget( #login_input_1, 200, 20, 180, 24, "" )
    ; ***
    TextGadget( #login_label_2, 20, 50, 180, 30, "Kennwort:" )
    StringGadget( #login_input_2, 200, 50, 180, 24, "", #PB_String_Password )
    ; ***
    ButtonGadget( #login_button_1, 280, 100, 100, 30, "Anmelden", #PB_Button_Default )
    ButtonGadget( #login_button_2, 170, 100, 100, 30, "Schließen" )
    ; ***
    AddKeyboardShortcut( #fenster1, #PB_Key_Escape, #hk_escape )
    AddKeyboardShortcut( #fenster1, #PB_Key_Return, #hk_enter )
  EndIf
EndProcedure

Procedure event_dlgLogin( evt.i )
  If Not IsWindow(#fenster1) : ProcedureReturn : EndIf
  If EventWindow() <> #fenster1 Or GetActiveWindow() <> #fenster1 : ProcedureReturn : EndIf
  ; ***
  Select evt
    Case #PB_Event_CloseWindow
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #login_button_1
          window_counter - 1
          ; ***
          show_dlgMain()
          ; ***
          CloseWindow(#fenster1)
        Case #login_button_2
          window_counter - 1
          ; ***
          CloseWindow(#fenster1)
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
        Case #hk_escape
          window_counter - 1
          ; ***
          CloseWindow(#fenster1)
        Case #hk_enter
          window_counter - 1
          ; ***
          CloseWindow(#fenster1)
      EndSelect
  EndSelect
EndProcedure

show_dlgMain()

With gvmr
  \viewmode = 0
  \measure = "cm"
  \id = #canvas2
  \img_back = 1300
  \img_rest = 1301
  \img_sele = 1302
  \img_temp = 1303
  \img_this = 1304
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

Repeat
  If window_counter <= 0
    Break
  Else
    loopE = WaitWindowEvent(50)
  EndIf
  ; ***
  event_dlgLogin(loopE)
  ; ***
  event_dlgMain(loopE)
  ; ***
  event_dlgAskLabel(loopE)
  ; ***
  event_dlgObjekt(loopE)
  ; ***
  event_newAdd(loopE)
  ; ***
  event_dlgSwichtObject(loopE)
  ; ***
  event_dlgSetup(loopE)
  ; ***
  event_dlgEdit(loopE)
  ; ***
  event_dlgInputText(loopE)
  ; ***
  event_dlgOpen(loopE)
  ; ***
  event_export(loopE)
  ; ***
  event_send(loopE)
ForEver

End

;
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 2228
; FirstLine = 390
; Folding = BAgAAA+
; EnableXP
; Executable = win_test\measureit.exe