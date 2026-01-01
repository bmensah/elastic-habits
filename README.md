# Elastic Habits
Habit tracking app for people who value consistency over perfection.

## Core Philosophy

Habit setting ambition can often be larger than current ability. Most habit tracking platform present a binary option: either the habit gets done, or it doesn't. This binary leads to many users failing to sustainably achieve ambitious new habit resolutions. Repeatedly failing to achieve a habit target leads to discouragement, causing users to drop a new habit all-together. 

Elastic Habits is a platform that allows user to track habits with a flexibility that is better-suited to the reality of variable motivation and circumstances.

Within the app, users can define the minimum level of effort required to count the habit as completed, as well as defining their target level of effort to aim for. They can also define which life events allow them to resort to a lower threshold to have a clear mitigation plan for known barriers to accomplishing a habit.

For example, a user may want to incorporate a running habit. Their habit set up could look something like this:

* Target: Run 3 miles a day
* Threshold 1: If I have to work late, run 1.5 miles
* Threshold 2: If I have to work late and I am sore, run 0.5 miles

As long as one of the thresholds is met, the habit is counted as completed. Through this method, users create a chain of completed habits regardless of motivation or unavoidable circumstances that positively enforces the internal belief that the habit is achievable.

## Development Log

### Day 1 

<table>
  <tr>
    <td width="40%">
      <img width="100%" alt="image" src="https://github.com/user-attachments/assets/a307ff8f-ec03-44be-a254-85b6f317d835" />
    </td>
    <td width="60%">
      <h3>Day 1</h3>
      <p>
        On day 1, I completed a basic setup to build on with just two habits
        and two threshold conditions.
      </p>
      <p>
        For each habit, there is a required tier based on the threshold
        conditions and the user's selected tier. These values are compared
        to determine whether the habit counts as completed or falls below
        the minimum requirement.
      </p>
    </td>
  </tr>
</table>



On day 1, I completed a basic set up to build on with just two habits and two threshold conditions.
<img width="150" height="375" alt="image" src="https://github.com/user-attachments/assets/a307ff8f-ec03-44be-a254-85b6f317d835" />

For each habit, there is a required tier based on the threshold conditions and the user's selected tier. These two values are compared to decide whether the user successfully completed the habit or failed to meet the minimum requirement. For example, if the user does not mark *Low Energy* or *Worked Late* for the **Exercise** habit but only completed it at the *C* threshold, the habit does not count as completed as they are below the minimum requirement of the *A* threshold. 

<img width="150" height="375" alt="image" src="https://github.com/user-attachments/assets/34856c51-9188-4f34-9e78-edf1a747581b" />

On the other hand, if they did have to work late, then accomplishing at least the *C* threshold counts as a success:

<img width="150" height="375" alt="image" src="https://github.com/user-attachments/assets/79f1670d-e5c2-46e7-a506-36b8c837a920" />

### Day 2


















