# Power BI Professional Theme: Step-by-Step Guide

## Overview
This guide will help you apply a professional theme to your SE Metrics Report to match the clean, modern FedLearn dashboard style with teal accents, white backgrounds, and subtle shadows.

---

## STEP 1: Download the Theme File

Save the `DISA_Professional_Theme.json` file to your computer (e.g., Documents folder).

---

## STEP 2: Open Your Report in Power BI Desktop

1. Open **Power BI Desktop**
2. Open your **SE Metrics Report111111** file

---

## STEP 3: Import the Custom Theme

1. Go to the **View** ribbon at the top
2. Click the dropdown arrow next to **Themes**
3. Select **Browse for themes**

   ![View > Themes > Browse for themes]

4. Navigate to where you saved `DISA_Professional_Theme.json`
5. Select the file and click **Open**
6. You'll see a success message: "Import theme successful"

---

## STEP 4: Verify Theme Applied

Your report should now show:
- **White backgrounds** on all visuals
- **Teal accent color** (#17A2B8) as primary data color
- **Clean gray text** (#333333 for titles, #828282 for subtitles)
- **Light gray page background** (#F5F5F5)

---

## STEP 5: Manual Adjustments for Best Results

After applying the theme, fine-tune these elements manually:

### A. Card Visuals (KPI boxes)
1. Select a card visual
2. In **Format** pane > **Callout value**:
   - Font: Segoe UI Light
   - Size: 28-32pt
   - Color: #333333 (dark gray)
3. In **Format** pane > **Category label**:
   - Font: Segoe UI
   - Size: 10pt
   - Color: #828282 (medium gray)

### B. Add Subtle Shadows
1. Select a visual
2. In **Format** pane > **Visual** > **Shadow**:
   - Toggle **ON**
   - Color: Black
   - Transparency: 85%
   - Size: 3px
   - Position: Outer, Below
   - Blur: 8px

### C. Page Background
1. Click on empty canvas area
2. In **Format** pane > **Canvas background**:
   - Color: #F5F5F5 (light gray)
   - Transparency: 0%

### D. Remove Visual Borders
1. Select each visual
2. In **Format** pane > **Visual** > **Border**:
   - Toggle **OFF**

---

## STEP 6: Customize the Header Area

To match the FedLearn dashboard header:

1. Insert a **Text box** for the title
   - Font: Segoe UI Semibold
   - Size: 24-28pt
   - Color: #333333

2. Add a **Date slicer** or **Text box** for refresh date
   - Font: Segoe UI
   - Size: 10pt
   - Color: #828282

---

## STEP 7: Style Tables to Match

For tables like the Exception List:

1. Select the table
2. **Format** pane > **Style presets** > Select "None"
3. **Format** pane > **Grid**:
   - Horizontal: ON, Color #F2F2F2
   - Vertical: ON, Color #F2F2F2
   - Row padding: 6-8px
4. **Format** pane > **Column headers**:
   - Font: Segoe UI Semibold
   - Size: 10pt
   - Background: #F9F9F9

---

## STEP 8: Create Status Indicators

For the "High Efficiency" badge with checkmark:

1. Insert a **Shape** (rounded rectangle)
   - Fill: Transparent or #FFFFFF
   - Border: None

2. Add a **Text box**:
   - Text: "✓ High" (use Unicode checkmark ✓)
   - Or use Icon visual with checkmark
   - Color: #27AE60 (green)
   - Font: Segoe UI Semibold

---

## STEP 9: Save Your Customized Theme

After making adjustments:

1. Go to **View** > **Themes** dropdown
2. Select **Save current theme**
3. Name it (e.g., "DISA SE Metrics Theme Final")
4. Click **Save**

This exports a JSON file you can reuse on other reports.

---

## Quick Reference: Color Palette

| Purpose | Hex Code | Usage |
|---------|----------|-------|
| Primary Teal | #17A2B8 | Main accent, key metrics |
| Dark Blue | #1E4D78 | Secondary data |
| Light Blue | #2D9CDB | Charts |
| Green (Good) | #27AE60 | Positive indicators |
| Red (Bad) | #EB5757 | Negative indicators |
| Dark Gray | #333333 | Primary text |
| Medium Gray | #828282 | Secondary text |
| Light Gray | #F2F2F2 | Borders, gridlines |
| Background | #F5F5F5 | Page background |
| White | #FFFFFF | Visual backgrounds |

---

## Troubleshooting

**Theme not applying to some visuals?**
- Some custom visuals don't support themes
- Manually format those visuals using the Format pane

**Colors look different?**
- Existing visuals with custom colors won't change
- Select visual > Format > Data colors > Reset to default

**Text not changing?**
- If using Classic or older themes, first switch to Default theme, then import custom theme

---

## Source
Based on Microsoft Learn documentation:
https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-report-themes
