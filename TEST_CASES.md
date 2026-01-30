# Manual Test Cases - Booking Conflict Detection

Use this guide to manually test if the system correctly detects booking conflicts.

---

## Prerequisites

1. App running at `http://localhost:8082`
2. Two teacher accounts (e.g., `ali@gmail.com` and `ahmad@gmail.com`)
3. One admin account

---

## Test Case 1: Basic Conflict Detection

**Scenario**: Teacher Ahmad tries to book a room already approved for Teacher Ali

| Step | Action                                                                   | Expected Result                                                                              |
| ---- | ------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------- |
| 1    | Login as **Teacher Ali**                                                 | See teacher dashboard                                                                        |
| 2    | Click "New Booking"                                                      | Booking form opens                                                                           |
| 3    | Select **Makmal Komputer**, Date: Tomorrow, Time: **1:00 PM - 2:00 PM**  | Form filled                                                                                  |
| 4    | Submit booking                                                           | "Booking submitted" message                                                                  |
| 5    | Login as **Admin**                                                       | Admin dashboard                                                                              |
| 6    | Find Ali's booking, click **Approve**                                    | Status changes to "Approved"                                                                 |
| 7    | Login as **Teacher Ahmad**                                               | Teacher dashboard                                                                            |
| 8    | Click "New Booking"                                                      | Booking form opens                                                                           |
| 9    | Select **same room, same date**, Time: **1:30 PM - 2:30 PM** (overlaps!) | Form filled                                                                                  |
| 10   | Submit booking                                                           | ❌ **Error message**: "This room is already booked by ali@gmail.com from 1:00 PM to 2:00 PM" |

**✅ PASS if**: Ahmad sees conflict error and booking is NOT saved

---

## Test Case 2: No Conflict - Different Times

**Scenario**: Ahmad books the same room but at a non-overlapping time

| Step | Action                                                             | Expected Result                      |
| ---- | ------------------------------------------------------------------ | ------------------------------------ |
| 1    | (After TC1) Login as **Teacher Ahmad**                             | Teacher dashboard                    |
| 2    | Click "New Booking"                                                | Booking form opens                   |
| 3    | Select **Makmal Komputer**, same date, Time: **3:00 PM - 4:00 PM** | Form filled                          |
| 4    | Submit booking                                                     | ✅ "Booking submitted" - No conflict |

**✅ PASS if**: Ahmad's booking is accepted (no overlap with 1-2 PM)

---

## Test Case 3: No Conflict - Different Room

**Scenario**: Ahmad books a different room at the same time

| Step | Action                                                                         | Expected Result                      |
| ---- | ------------------------------------------------------------------------------ | ------------------------------------ |
| 1    | Login as **Teacher Ahmad**                                                     | Teacher dashboard                    |
| 2    | Click "New Booking"                                                            | Booking form opens                   |
| 3    | Select **Bilik Seni** (different room), same date, Time: **1:30 PM - 2:30 PM** | Form filled                          |
| 4    | Submit booking                                                                 | ✅ "Booking submitted" - No conflict |

**✅ PASS if**: Ahmad's booking is accepted (different room)

---

## Test Case 4: Pending Booking - No Conflict

**Scenario**: Pending bookings should NOT block new bookings

| Step | Action                                                            | Expected Result                             |
| ---- | ----------------------------------------------------------------- | ------------------------------------------- |
| 1    | Login as **Teacher Ali**                                          | Teacher dashboard                           |
| 2    | Create booking for **Makmal Sains**, Time: **9:00 AM - 10:00 AM** | Booking submitted (PENDING)                 |
| 3    | **DO NOT approve** (leave as Pending)                             | Status = Pending                            |
| 4    | Login as **Teacher Ahmad**                                        | Teacher dashboard                           |
| 5    | Book **same room, same time**: **9:00 AM - 10:00 AM**             | Form filled                                 |
| 6    | Submit booking                                                    | ✅ Booking accepted (Pending doesn't block) |

**✅ PASS if**: Ahmad can book because Ali's is still Pending (not Approved)

---

## Test Case 5: Capacity Exceeded

| Step | Action                                    | Expected Result                                                    |
| ---- | ----------------------------------------- | ------------------------------------------------------------------ |
| 1    | Login as Teacher                          | Dashboard                                                          |
| 2    | Click "New Booking"                       | Form opens                                                         |
| 3    | Select **Bilik Mesyuarat** (capacity: 15) | Room selected                                                      |
| 4    | Enter **20 students**                     | Form filled                                                        |
| 5    | Submit booking                            | ❌ **Error**: "Number of students (20) exceeds room capacity (15)" |

**✅ PASS if**: Booking rejected due to capacity exceeded

---

## Test Results Summary

| Test Case | Description                  | Result            |
| --------- | ---------------------------- | ----------------- |
| TC1       | Basic conflict detection     | ⬜ Pass / ⬜ Fail |
| TC2       | No conflict (different time) | ⬜ Pass / ⬜ Fail |
| TC3       | No conflict (different room) | ⬜ Pass / ⬜ Fail |
| TC4       | Pending doesn't block        | ⬜ Pass / ⬜ Fail |
| TC5       | Capacity exceeded            | ⬜ Pass / ⬜ Fail |

---

**Tested by**: ******\_\_\_\_******  
**Date**: ******\_\_\_\_******
