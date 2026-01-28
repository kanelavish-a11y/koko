# DISA Workforce Analytics — Dashboard Build Guide

**Reference Documentation:**  
- [Use report themes in Power BI Desktop](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-report-themes)  
- [Report Theme JSON Schema](https://github.com/microsoft/powerbi-desktop-samples/tree/main/Report%20Theme%20JSON%20Schema)

---

## Phase 1: Theme Setup

### 1.1 Import the DISA Navy Theme

Per Microsoft Learn: *"To import a custom report theme file, on the View ribbon, select the Themes dropdown button > Browse for themes."*

**Steps:**
1. Open Power BI Desktop
2. Go to **View** ribbon → **Themes** dropdown
3. Select **Browse for themes**
4. Navigate to and select `DISA_Navy_Theme.json`
5. Click **Open**

If successful, you'll see: *"Import theme successful"*

**If you get an error:**  
Per Microsoft: *"Power BI validates custom themes based on a JSON schema. If Power BI finds fields it doesn't understand, it shows you a message letting you know that the theme file is invalid."*

The DISA Navy theme has been validated against Microsoft's documented schema requirements.

### 1.2 Theme Color Reference

Per Microsoft Learn, themes have four main components:
1. **Theme colors** (dataColors, good/neutral/bad, gradient colors)
2. **Structural colors** (firstLevelElements, background, etc.)
3. **Text classes** (callout, title, header, label)
4. **Visual styles** (optional advanced formatting)

#### Data Colors (Chart Series)
| Order | Hex | Color | Use |
|-------|-----|-------|-----|
| 1 | #F4B942 | Gold | Primary accent |
| 2 | #3B82F6 | Blue | Secondary |
| 3 | #10B981 | Green | Positive/Good |
| 4 | #EF4444 | Red | Negative/Bad |
| 5 | #8B5CF6 | Purple | Tertiary |
| 6 | #F97316 | Orange | Warning |
| 7 | #06B6D4 | Cyan | Highlight |

#### Status Colors (KPI, Waterfall)
| Property | Hex | Use |
|----------|-----|-----|
| good | #10B981 | Positive status |
| neutral | #F4B942 | Neutral status |
| bad | #EF4444 | Negative status |

#### Structural Colors
Per Microsoft: *"These color classes set the structural colors for elements in the report, such as axis gridlines, highlight colors, and background colors."*

| Property | Hex | What it formats |
|----------|-----|-----------------|
| firstLevelElements | #F8FAFC | Card data labels, slicer text, KPI text, table values |
| secondLevelElements | #94A3B8 | Legend text, axis labels, slicer items |
| thirdLevelElements | #1E3A5F | Axis gridlines, table grid |
| background | #0F172A | Label backgrounds, button fills |
| secondaryBackground | #1E293B | Table outline, disabled buttons |
| tableAccent | #F4B942 | Table grid outline |

#### Text Classes
Per Microsoft: *"You only need to set four primary classes to change all text formatting: callout, title, header, and label."*

| Class | Font | Size | Color | Used For |
|-------|------|------|-------|----------|
| callout | Segoe UI Semibold | 32pt | #F8FAFC | Card values, KPI |
| title | Segoe UI Semibold | 12pt | #F8FAFC | Axis titles |
| header | Segoe UI Semibold | 12pt | #F8FAFC | Key influencers |
| label | Segoe UI | 10pt | #94A3B8 | Table values, data labels |

---

## Phase 2: Canvas Setup

### 2.1 Set Canvas Size (Each Page)

1. Click empty canvas area
2. **Format pane** → **Canvas settings**
3. Set **Type**: Custom
4. **Width**: 1920
5. **Height**: 1080

### 2.2 Apply Backgrounds

| Page | File |
|------|------|
| 1 | disa_1_executive.png |
| 2 | disa_2_attrition.png |
| 3 | disa_3_retention.png |
| 4 | disa_4_movement.png |
| 5 | disa_5_newhire.png |

**For each page:**
1. Click empty canvas
2. **Format** → **Canvas background**
3. **+ Add image** → Browse → Select PNG
4. **Image fit**: Fit
5. **Transparency**: 0%

---

## Phase 3: DAX Measures

### 3.1 Calculated Column (Fact_PersonnelActions)

```dax
Voluntary_Flag = 
VAR NOA = Fact_PersonnelActions[NOA Code]
RETURN
    NOA = "302" ||
    LEFT(NOA, 2) = "31" ||
    NOA = "352"
```

### 3.2 Core Measures

```dax
// === VOLUNTARY / NON-VOLUNTARY ===
Voluntary Losses = 
CALCULATE([Total Losses], Fact_PersonnelActions[Voluntary_Flag] = TRUE)

Non-Voluntary Losses = 
CALCULATE([Total Losses], Fact_PersonnelActions[Voluntary_Flag] = FALSE)

Voluntary Attrition Rate = 
DIVIDE([Voluntary Losses], [Average On-Hand Count], 0) * 100

Non-Voluntary Attrition Rate = 
DIVIDE([Non-Voluntary Losses], [Average On-Hand Count], 0) * 100

// === NET CHANGE ===
Net Workforce Change = 
[On-Hand Count (End)] - [On-Hand Count (Start)]

// === TARGETS ===
Attrition Target = 15
Retention Target = 85

Attrition vs Target = [Attrition Rate] - [Attrition Target]
Retention vs Target = [Retention Rate] - [Retention Target]

// === DYNAMIC TITLE ===
Dynamic Title = 
VAR StartDt = MIN(Dim_Date[SnapshotDate])
VAR EndDt = MAX(Dim_Date[SnapshotDate])
VAR OrgFilter = IF(
    ISFILTERED(Dim_Organization[Org]),
    SELECTEDVALUE(Dim_Organization[Org], "Multiple"),
    "All Organizations"
)
RETURN
"DISA Workforce Analytics: " & 
FORMAT(StartDt, "DD MMM YYYY") & " to " & 
FORMAT(EndDt, "DD MMM YYYY") & " | " & OrgFilter
```

---

## Phase 4: Visual Formatting

### 4.1 Default Visual Settings

Per Microsoft: *"When you apply a report theme, all visuals in your report use the colors and formatting from your selected theme as their defaults."*

However, for transparent backgrounds over custom images:

**For each visual:**
1. Select the visual
2. **Format** → **General** → **Effects**
3. **Background**: Toggle OFF
4. **Visual border**: Toggle OFF
5. **Format** → **General** → **Header icons**: Toggle OFF

### 4.2 Slicer Positions

| Slicer | X | Y | W | H |
|--------|---|---|---|---|
| Start Date | 14 | 65 | 180 | 55 |
| End Date | 204 | 65 | 180 | 55 |
| Org | 394 | 65 | 220 | 55 |

### 4.3 Card Formatting

The theme's `callout` text class sets card values to:
- Font: Segoe UI Semibold
- Size: 32pt
- Color: #F8FAFC (white)

If cards don't pick up theme colors:
1. Select card
2. **Format** → **Callout value**
3. **Color** → Select from theme colors or manually set #F8FAFC

---

## Phase 5: Page Layouts

### PAGE 1: Executive Summary

**Dynamic Title** (Header)
| X | Y | W | H |
|---|---|---|---|
| 14 | 10 | 800 | 40 |

**KPI Cards**
| Measure | X | Y | W | H |
|---------|---|---|---|---|
| Attrition Rate | 14 | 134 | 466 | 100 |
| Retention Rate | 494 | 134 | 466 | 100 |
| Net Change | 974 | 134 | 466 | 100 |
| VS Target (Gauge) | 1454 | 134 | 466 | 100 |

**Charts**
| Visual | X | Y | W | H |
|--------|---|---|---|---|
| Trend (Stacked Area) | 14 | 248 | 1217 | 280 |
| Vol/Non-Vol (Donut) | 1245 | 248 | 661 | 280 |
| Needs Attention (Table) | 14 | 542 | 618 | 524 |
| By Org (Bar) | 646 | 542 | 618 | 524 |
| Reasons (Bar) | 1278 | 542 | 618 | 524 |

### PAGE 2: Attrition Analysis

**KPIs**
| Measure | X | Y | W | H |
|---------|---|---|---|---|
| Total Attrition | 14 | 134 | 466 | 85 |
| Voluntary Rate | 494 | 134 | 466 | 85 |
| Non-Vol Rate | 974 | 134 | 466 | 85 |
| Total Losses | 1454 | 134 | 466 | 85 |

**Charts**
| Visual | X | Y | W | H |
|--------|---|---|---|---|
| Vol/Non-Vol Trend | 14 | 233 | 1036 | 260 |
| Why Voluntary | 1064 | 233 | 842 | 122 |
| Why Non-Vol | 1064 | 369 | 842 | 124 |
| Risk Heatmap | 14 | 507 | 618 | 559 |
| By Tenure | 646 | 507 | 618 | 559 |
| By Org | 1278 | 507 | 618 | 559 |

### PAGE 3: Retention Analysis

**KPIs**
| Measure | X | Y | W | H |
|---------|---|---|---|---|
| Retention Rate | 14 | 134 | 622 | 90 |
| VS Target | 650 | 134 | 622 | 90 |
| Remaining | 1286 | 134 | 620 | 90 |

**Charts**
| Visual | X | Y | W | H |
|--------|---|---|---|---|
| By Milestone | 14 | 238 | 939 | 270 |
| Flight Risk | 967 | 238 | 939 | 270 |
| By Org | 14 | 522 | 939 | 544 |
| Trend | 967 | 522 | 939 | 544 |

### PAGE 4: Workforce Movement

**KPIs (5 cards)**
| Measure | X | Y | W | H |
|---------|---|---|---|---|
| Headcount | 14 | 134 | 370 | 80 |
| Gains | 398 | 134 | 370 | 80 |
| Losses | 782 | 134 | 370 | 80 |
| Internal | 1166 | 134 | 370 | 80 |
| External | 1550 | 134 | 370 | 80 |

**Charts**
| Visual | X | Y | W | H |
|--------|---|---|---|---|
| Flow Diagram | 14 | 228 | 1133 | 280 |
| Movement Type | 1161 | 228 | 745 | 280 |
| Net by Org | 14 | 522 | 939 | 544 |
| Destinations | 967 | 522 | 939 | 544 |

### PAGE 5: New Hire Success

**KPIs**
| Measure | X | Y | W | H |
|---------|---|---|---|---|
| New Hires | 14 | 134 | 466 | 85 |
| 1st Year Attrition | 494 | 134 | 466 | 85 |
| Losses | 974 | 134 | 466 | 85 |
| Survival Rate | 1454 | 134 | 466 | 85 |

**Charts**
| Visual | X | Y | W | H |
|--------|---|---|---|---|
| Survival Curve | 14 | 233 | 939 | 260 |
| Hiring vs Attrition | 967 | 233 | 939 | 260 |
| Why Leave | 14 | 507 | 939 | 559 |
| By Org | 967 | 507 | 939 | 559 |

---

## Phase 6: Conditional Formatting

### Add Reference/Target Lines

1. Select bar chart
2. **Format** → **Analytics** (or **Add further analyses**)
3. Add **Constant line**
4. Value: 15 (for attrition) or 85 (for retention)
5. Color: #F8FAFC
6. Style: Dashed

### Conditional Bar Colors

1. Select bar chart
2. **Format** → **Bars** → **Colors**
3. Click **fx** (conditional formatting)
4. **Format style**: Rules
5. Add rule: If value > 15 then #EF4444 (red)

---

## Phase 7: Troubleshooting

### Theme Colors Not Applying

Per Microsoft: *"Setting a report theme changes the default colors used in visuals throughout the report."* However, explicitly set colors override the theme.

**To reset:**
1. Select visual
2. **Format** → **Data colors** (or relevant setting)
3. Click **Reset to default**

### Text Not Visible on Dark Background

Per Microsoft's dark theme guidance: *"Set the color's firstLevelElements (matching the primary text color), secondLevelElements (matching the anticipated light color for text), and background (with sufficient contrast)."*

The DISA Navy theme follows this pattern:
- firstLevelElements: #F8FAFC (white)
- secondLevelElements: #94A3B8 (light gray)
- background: #0F172A (dark navy)

If text is still dark, manually set:
1. **Format** → **Data labels** → **Color**: #F8FAFC
2. **Format** → **X-axis** / **Y-axis** → **Color**: #94A3B8

### Theme Import Error

Per Microsoft: *"Power BI validates custom themes based on a JSON schema."*

Common issues:
- Missing commas between properties
- Trailing comma after last array item
- Invalid hex codes (must be #RGB or #RRGGBB)
- Misspelled property names

---

## Pre-Publish Checklist

- [ ] Theme imported without errors
- [ ] All 5 backgrounds applied
- [ ] Canvas size 1920×1080 on all pages
- [ ] Visual backgrounds transparent
- [ ] Visual borders OFF
- [ ] Visual headers OFF
- [ ] Text visible (white/light gray)
- [ ] Slicers functional
- [ ] Target lines added
- [ ] Conditional formatting applied
- [ ] Dynamic title working

---

## Reference Links

- [Power BI Desktop Report Themes](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-report-themes)
- [Theme JSON Schema (GitHub)](https://github.com/microsoft/powerbi-desktop-samples/tree/main/Report%20Theme%20JSON%20Schema)
- [Power BI Community Theme Gallery](https://community.powerbi.com/t5/Themes-Gallery/bd-p/ThemesGallery)
