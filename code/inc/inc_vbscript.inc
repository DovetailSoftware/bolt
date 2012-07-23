<SCRIPT Runat=Server Language=VBScript>
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Product        : Dovetail Agent
''
'' Series         : Dovetail Software Web Series(tm)
''
'' Name           : inc_vbscript.inc
''
'' Description    : Common VBScript Functions
''
'' Author         : Dovetail Software, Inc.
''                  4807 Spicewood Springs Rd, Bldg 4 Suite 200
''                  Austin, TX 78759
''                  (512) 610-5400
''                  EMAIL: support@dovetailsoftware.com
''                  www.dovetailsoftware.com
''
'' Platforms      : This version supports Clarify 4.5 and later
''
'' Copyright (C) 2002 Dovetail Software, Inc.
'' All Rights Reserved.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Function vbDateAdd(interval, number, date)
   vbDateAdd=DateAdd(interval, number, date)
End Function

Function vbDateDiff(interval, date1, date2)
   vbDateDiff=DateDiff(interval, date1, date2)
End Function

Function I18N_FormatShortDate(inDate)
  I18N_FormatShortDate = FormatDateTime(inDate,vbShortDate)
End Function

Function I18N_FormatGeneralDate(inDate)
  I18N_FormatGeneralDate = FormatDateTime(inDate,vbGeneralDate)
End Function

Function I18N_FormatLongDate(inDate)
  I18N_FormatLongDate = FormatDateTime(inDate,vbLongDate)
End Function

Function I18N_FormatShortTime(inTime)
  I18N_FormatShortTime = FormatDateTime(inTime,vbShortTime)
End Function

Function I18N_FormatLongTime(inTime)
  I18N_FormatLongTime = FormatDateTime(inTime,vbLongTime)
End Function

Function vbCDate(inStr)
  vbCDate = CDate(inStr)
End Function

Function vbTodaysLongDate()
  vbTodaysLongDate = WeekDayName(WeekDay(Now)) & ", " & MonthName(Month(Now)) & " " & Day(Now) & ", " & Year(Now)
End Function

Function vbLongDate()
  vbLongDate = WeekDayName(WeekDay(Now)) & ", " & MonthName(Month(Now)) & " " & Day(Now) & ", " & Year(Now)
End Function

Function vbTestDate()
  On Error Resume Next
  Dim tDate
  tDate = CDate("8-Feb-2004")
  If Err Then
     vbTestDate = I18N_FormatShortDate(Now)
  Else
     vbTestDate = I18N_FormatShortDate(tDate)
  End If
End Function

Function vbIsNull(inData)
  vbIsNull = IsNull(inData)
End Function

Function vbNow()
  vbNow = Now
End Function

Function vbFormatCurrency(Expression, NumDigitsAfterDecimal, IncludeLeadingDigit, UseParensForNegativeNumbers, GroupDigit)
  vbFormatCurrency = FormatCurrency(Expression, NumDigitsAfterDecimal, IncludeLeadingDigit, UseParensForNegativeNumbers, GroupDigit)
End Function

Function vbPrettyDateOnly(inDate)
Dim end_dt
Dim zero_dt
Dim t_date
Dim out_date
  zero_dt = FormatDateTime("1/1/1753",vbShortDate)
  end_dt  = FormatDateTime("4712-12-31 00:00:00",vbShortDate)

  t_date  = FormatDateTime(inDate,vbShortDate)
  out_date = t_date
  If t_date = zero_dt Then out_date = "?/?/?"
  If t_date =  end_dt Then out_date = "*/*/*"
  vbPrettyDateOnly = out_date
End Function

Function vbPrettyDate(inDate)
Dim end_dt
Dim zero_dt
Dim t_date
Dim out_date
  zero_dt = FormatDateTime("1/1/1753",vbGeneralDate)
  end_dt  = FormatDateTime("4712-12-31 00:00:00",vbShortDate)
  t_date  = FormatDateTime(inDate,vbGeneralDate)
  out_date = t_date
  If t_date = zero_dt Then out_date = "?/?/? ?:?:?"
  If t_date =  end_dt Then out_date = "*/*/* *:*:*"
  vbPrettyDate = out_date
End Function


</SCRIPT>
