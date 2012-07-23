<script runat=server language=vbscript>
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
</script>
