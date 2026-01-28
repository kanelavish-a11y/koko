# DISA Workforce Analytics — Dashboard Build Guide

## Setup Checklist

| Step | Task | Time |
|------|------|------|
| 1 | Apply theme + backgrounds | 20 min |
| 2 | Add new measures | 30 min |
| 3 | Build Page 1 (Executive) | 45 min |
| 4 | Build Page 2 (Attrition) | 45 min |
| 5 | Build Page 3 (Retention) | 30 min |
| 6 | Build Page 4 (Movement) | 30 min |
| 7 | Build Page 5 (New Hire) | 30 min |

---

## Phase 1: Setup

### 1.1 Apply Theme
1. View → Themes → Browse for themes
2. Select `DISA_Dark_Theme.json`
3. Apply

### 1.2 Set Canvas Size (Each Page)
1. Format pane → Canvas settings
2. Type: Custom
3. Width: 1920, Height: 1080

### 1.3 Apply Backgrounds
| Page | Background File |
|------|-----------------|
| 1 | `v3_1_executive.png` |
| 2 | `v3_2_attrition.png` |
| 3 | `v3_3_retention.png` |
| 4 | `v3_4_movement.png` |
| 5 | `v3_5_newhire.png` |

For each page:
1. Click empty canvas
2. Format → Canvas background → Browse
3. Select the PNG file
4. Transparency: 0%

---

## Phase 2: Add Measures

### 2.1 Voluntary Flag (Calculated Column)
Add to `Fact_PersonnelActions`:

```dax
Voluntary_Flag = 
VAR NOA = Fact_PersonnelActions[NOA Code]
RETURN
    NOA = "302" ||
    LEFT(NOA, 2) = "31" ||
    NOA = "352"
```

### 2.2 Core Measures
Add these to your Measures table:

```dax
// Voluntary/Non-Voluntary Losses
Voluntary Losses = 
CALCULATE([Total Losses], Fact_PersonnelActions[Voluntary_Flag] = TRUE)

Non-Voluntary Losses = 
CALCULATE([Total Losses], Fact_PersonnelActions[Voluntary_Flag] = FALSE)

// Voluntary/Non-Voluntary Rates
Voluntary Attrition Rate = 
DIVIDE([Voluntary Losses], [Average On-Hand Count], 0) * 100

Non-Voluntary Attrition Rate = 
DIVIDE([Non-Voluntary Losses], [Average On-Hand Count], 0) * 100

// Net Change
Net Workforce Change = 
[On-Hand Count (End)] - [On-Hand Count (Start)]

// Target Comparisons
Attrition Target = 15

Attrition vs Target = 
[Attrition Rate] - [Attrition Target]

Retention Target = 85

Retention vs Target = 
[Retention Rate] - [Retention Target]

// Internal/External
External Losses = 
CALCULATE(
    COUNTROWS(Fact_PersonnelActions),
    Fact_PersonnelActions[NOA Code] IN {"302","312","317","330","352","355","357","385"} ||
    LEFT(Fact_PersonnelActions[NOA Code], 1) = "3" ||
    Fact_PersonnelActions[NOA Code] = "T352" ||
    Fact_PersonnelActions[NOA Code] = "CAO",
    Fact_PersonnelActions[Compare Columns] = "DIFFERENT"
)

Internal Moves = 
CALCULATE(
    COUNTROWS(Fact_PersonnelActions),
    Fact_PersonnelActions[NOA Code] IN {"501", "570", "702", "721"},
    Fact_PersonnelActions[Compare Columns] = "DIFFERENT"
)

// New Hire Metrics
New Hire Losses = 
CALCULATE([Total Losses], Fact_PersonnelActions[Tenure at Departure] < 2)

First Year Attrition Rate = 
VAR Losses = CALCULATE([Total Losses], Fact_PersonnelActions[Tenure at Departure] < 1)
VAR Pool = CALCULATE([On-Hand Count (Start)], Fact_EmployeeSnapshot[Tenure Years] < 2)
RETURN DIVIDE(Losses, Pool, 0) * 100
```

---

## Phase 3: Build Pages

### Global Settings (Apply to ALL Visuals)
```
Format → General → Effects:
  - Background: OFF
  - Border: OFF
  
Format → General → Header icons: OFF

Format → Title:
  - Font color: #F8FAFC (white)
  - Font size: 11
```

### Slicer Settings (All Pages)
| Slicer | X | Y | W | H |
|--------|---|---|---|---|
| Start Date | 14 | 65 | 180 | 55 |
| End Date | 204 | 65 | 180 | 55 |
| Org | 394 | 65 | 220 | 55 |

Slicer format:
- Background: Transparent
- Font color: White (#F8FAFC)
- Border: OFF

---

## PAGE 1: Executive Summary

### Dynamic Title (Header Area)
| Element | X | Y | W | H |
|---------|---|---|---|---|
| Text box / Card | 14 | 10 | 600 | 40 |

Use a card or text box with your dynamic title measure.

### KPI Cards
| Card | Measure | X | Y | W | H | Accent |
|------|---------|---|---|---|---|--------|
| 1 | Attrition Rate | 14 | 134 | 466 | 100 | Orange |
| 2 | Retention Rate | 494 | 134 | 466 | 100 | Teal |
| 3 | Net Workforce Change | 974 | 134 | 466 | 100 | Blue |
| 4 | VS Target (Gauge) | 1454 | 134 | 466 | 100 | Green |

**Card 1-3 Settings:**
- Visual: Card
- Callout value: 32pt, White
- Category label: 11pt, Gray (#94A3B8)

**Card 4 Settings:**
- Visual: Gauge
- Value: [Attrition Rate]
- Target: 15
- Max: 25
- Colors: Green below target, Red above

### Main Charts (Row 2)
| Chart | X | Y | W | H |
|-------|---|---|---|---|
| Attrition Trend | 14 | 248 | 1217 | 280 |
| Vol vs Non-Vol Donut | 1245 | 248 | 661 | 280 |

**Attrition Trend:**
- Visual: Stacked Area Chart
- X-Axis: Dim_Date[YearMonth]
- Values: [Voluntary Attrition Rate], [Non-Voluntary Attrition Rate]
- Colors: Amber (#F59E0B) for Vol, Red (#EF4444) for Non-Vol

**Vol vs Non-Vol Donut:**
- Visual: Donut Chart
- Values: [Voluntary Losses], [Non-Voluntary Losses]
- Detail labels: Category, Value, Percent
- Colors: Amber, Red

### Bottom Row
| Chart | X | Y | W | H |
|-------|---|---|---|---|
| Needs Attention | 14 | 542 | 618 | 524 |
| Attrition by Org | 646 | 542 | 618 | 524 |
| Top Departure Reasons | 1278 | 542 | 618 | 524 |

**Needs Attention:**
- Visual: Table
- Columns: Org, [Attrition Rate], [Attrition vs Target]
- Sort: Attrition Rate DESC
- Top N: 5
- Conditional formatting: Red if Attrition Rate > 15

**Attrition by Org:**
- Visual: Clustered Bar Chart
- Y-Axis: Org
- X-Axis: [Attrition Rate]
- Add constant line at 15%
- Conditional formatting: Red bars if > 15%

**Top Departure Reasons:**
- Visual: Clustered Bar Chart
- Y-Axis: Departure Reason (or NOA Description)
- X-Axis: Count
- Top N: 7

---

## PAGE 2: Attrition Analysis

### KPI Cards
| Card | Measure | X | Y | W | H | Accent |
|------|---------|---|---|---|---|--------|
| 1 | Attrition Rate | 14 | 134 | 466 | 85 | Orange |
| 2 | Voluntary Attrition Rate | 494 | 134 | 466 | 85 | Amber |
| 3 | Non-Voluntary Attrition Rate | 974 | 134 | 466 | 85 | Red |
| 4 | Total Losses | 1454 | 134 | 466 | 85 | Blue |

### Main Charts (Row 2)
| Chart | X | Y | W | H |
|-------|---|---|---|---|
| Vol vs Non-Vol Trend | 14 | 233 | 1036 | 260 |
| Why Voluntary? | 1064 | 233 | 842 | 122 |
| Why Non-Voluntary? | 1064 | 369 | 842 | 124 |

**Vol vs Non-Vol Trend:**
- Visual: Stacked Area Chart
- Same as Page 1

**Why Voluntary?:**
- Visual: Clustered Bar Chart
- Filter: Voluntary_Flag = TRUE
- Y-Axis: Departure Reason
- X-Axis: Count

**Why Non-Voluntary?:**
- Visual: Clustered Bar Chart  
- Filter: Voluntary_Flag = FALSE
- Y-Axis: Departure Reason
- X-Axis: Count

### Bottom Row
| Chart | X | Y | W | H |
|-------|---|---|---|---|
| Risk Heatmap | 14 | 507 | 618 | 559 |
| By Tenure Bucket | 646 | 507 | 618 | 559 |
| By Organization | 1278 | 507 | 618 | 559 |

**Risk Heatmap:**
- Visual: Matrix
- Rows: Org
- Columns: Tenure Bucket
- Values: [Attrition Rate]
- Conditional formatting: Background color scale (Green → Yellow → Red)

**By Tenure Bucket:**
- Visual: Clustered Bar Chart
- Y-Axis: Tenure Bucket
- X-Axis: [Attrition Rate]

**By Organization:**
- Visual: Clustered Bar Chart
- Y-Axis: Org
- X-Axis: [Total Losses]

---

## PAGE 3: Retention Analysis

### KPI Cards
| Card | Measure | X | Y | W | H | Accent |
|------|---------|---|---|---|---|--------|
| 1 | Retention Rate | 14 | 134 | 622 | 90 | Teal |
| 2 | VS Target (Gauge) | 650 | 134 | 622 | 90 | Green |
| 3 | Remaining Count | 1286 | 134 | 620 | 90 | Blue |

### Main Charts (Row 2)
| Chart | X | Y | W | H |
|-------|---|---|---|---|
| Retention by Milestone | 14 | 238 | 939 | 270 |
| Flight Risk | 967 | 238 | 939 | 270 |

**Retention by Milestone:**
- Visual: Funnel or Bar Chart
- Show retention at: 1yr, 2yr, 5yr, 10yr marks
- (Requires custom measures for each milestone)

**Flight Risk:**
- Visual: Table
- Columns: Org, [Retention Rate]
- Filter: Retention Rate < 80
- Conditional formatting: Red background
- Sort: Retention Rate ASC

### Bottom Row
| Chart | X | Y | W | H |
|-------|---|---|---|---|
| Retention by Org | 14 | 522 | 939 | 544 |
| Retention Trend | 967 | 522 | 939 | 544 |

**Retention by Org:**
- Visual: Clustered Bar Chart
- Y-Axis: Org
- X-Axis: [Retention Rate]
- Add constant line at 85%
- Conditional formatting: Red if < 80%

**Retention Trend:**
- Visual: Line Chart
- X-Axis: Month
- Y-Axis: [Retention Rate]
- Add 85% reference line

---

## PAGE 4: Workforce Movement

### KPI Cards
| Card | Measure | X | Y | W | H | Accent |
|------|---------|---|---|---|---|--------|
| 1 | On-Hand (End) | 14 | 134 | 370 | 80 | Blue |
| 2 | Gains | 398 | 134 | 370 | 80 | Green |
| 3 | Total Losses | 782 | 134 | 370 | 80 | Red |
| 4 | Internal Moves | 1166 | 134 | 370 | 80 | Purple |
| 5 | External Exits | 1550 | 134 | 370 | 80 | Orange |

### Main Charts (Row 2)
| Chart | X | Y | W | H |
|-------|---|---|---|---|
| Where Do People Go? | 14 | 228 | 1133 | 280 |
| Movement Type | 1161 | 228 | 745 | 280 |

**Where Do People Go?:**
- Visual: Sankey (from AppSource) or Clustered Bar
- If Sankey: Source = From Org, Destination = To Org or "External"
- If Bar: Show movement counts by destination

**Movement Type:**
- Visual: Donut or Treemap
- Categories: Promotion (702), Lateral (721), Reassignment, Retirement, Resignation, etc.
- Values: Count

### Bottom Row
| Chart | X | Y | W | H |
|-------|---|---|---|---|
| Net Movement by Org | 14 | 522 | 939 | 544 |
| Top Destinations | 967 | 522 | 939 | 544 |

**Net Movement by Org:**
- Visual: Waterfall or Clustered Bar
- Show: Starting count → Gains → Losses → Ending count
- Or: Bar chart with [Net Workforce Change] by Org

**Top Destinations:**
- Visual: Clustered Bar Chart
- Y-Axis: Destination Agency (for external moves)
- X-Axis: Count
- Filter: External movements only

---

## PAGE 5: New Hire Success

### KPI Cards
| Card | Measure | X | Y | W | H | Accent |
|------|---------|---|---|---|---|--------|
| 1 | New Hire Count | 14 | 134 | 466 | 85 | Green |
| 2 | First Year Attrition | 494 | 134 | 466 | 85 | Orange |
| 3 | New Hire Losses | 974 | 134 | 466 | 85 | Red |
| 4 | Survival Rate | 1454 | 134 | 466 | 85 | Teal |

**Survival Rate measure:**
```dax
New Hire Survival Rate = 100 - [First Year Attrition Rate]
```

### Main Charts (Row 2)
| Chart | X | Y | W | H |
|-------|---|---|---|---|
| Survival Curve | 14 | 233 | 939 | 260 |
| Hiring vs Attrition | 967 | 233 | 939 | 260 |

**Survival Curve:**
- Visual: Line Chart
- X-Axis: Time milestone (90 days, 180 days, 1 year, 2 years)
- Y-Axis: % still employed
- (Requires custom survival measures)

**Hiring vs Attrition:**
- Visual: Combo Chart
- Bars: New Hires, Losses by month
- Line: Net (Hires - Losses)

### Bottom Row
| Chart | X | Y | W | H |
|-------|---|---|---|---|
| Why New Hires Leave | 14 | 507 | 939 | 559 |
| New Hire Attrition by Org | 967 | 507 | 939 | 559 |

**Why New Hires Leave:**
- Visual: Clustered Bar Chart
- Y-Axis: Departure Reason
- X-Axis: Count
- Filter: Tenure at Departure < 2

**New Hire Attrition by Org:**
- Visual: Clustered Bar Chart
- Y-Axis: Org
- X-Axis: New Hire Attrition Rate (or count)
- Filter context to new hires

---

## Quick Reference: Colors

| Purpose | Hex | RGB |
|---------|-----|-----|
| Primary (Attrition) | #F59E0B | (245, 158, 11) |
| Teal (Retention) | #14B8A6 | (20, 184, 166) |
| Blue (Headcount) | #3B82F6 | (59, 130, 246) |
| Red (Losses/Bad) | #EF4444 | (239, 68, 68) |
| Green (Good/Target) | #22C55E | (34, 197, 94) |
| Purple (Movement) | #8B5CF6 | (139, 92, 246) |
| Amber (Voluntary) | #F59E0B | (245, 158, 11) |
| Cyan (Trends) | #06B6D4 | (6, 182, 212) |
| Text Light | #F8FAFC | (248, 250, 252) |
| Text Dim | #94A3B8 | (148, 163, 184) |

---

## Checklist: Before Publishing

- [ ] All visuals have transparent backgrounds
- [ ] All visual borders are OFF
- [ ] All visual headers are OFF
- [ ] Title text is white (#F8FAFC)
- [ ] Data labels are white
- [ ] Slicers work across all pages (if synced)
- [ ] Target lines appear on bar charts
- [ ] Conditional formatting applied (red/green)
- [ ] Dynamic title shows correct date range
- [ ] Mobile view configured (optional)
