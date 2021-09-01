/*:

## Fueled Swift Exercise

A blogging platform stores the following information that is available through separate API endpoints:
+ user accounts
+ blog posts for each user
+ comments for each blog post

### Objective
The organization needs to identify the 3 most engaging bloggers on the platform. Using only Swift and the Foundation library, output the top 3 users with the highest average number of comments per post in the following format:

&nbsp;&nbsp;&nbsp; `[name]` - `[id]`, Score: `[average_comments]`

Instead of connecting to a remote API, we are providing this data in form of JSON files, which have been made accessible through a custom Resource enum with a `data` method that provides the contents of the file.

### What we're looking to evaluate
1. How you choose to model your data
2. How you transform the provided JSON data to your data model
3. How you use your models to calculate this average value
4. How you use this data point to sort the users

*/

import Foundation

/*:
1. First, start by modeling the data objects that will be used.
*/

/*:
2. Next, decode the JSON source using `Resource.users.data()`.
*/

/*:
3. Next, use your populated models to calculate the average number of comments per user.
*/

/*:
4. Finally, use your calculated metric to find the 3 most engaging bloggers, sort order, and output the result.
*/

let userList = try JSONDecoder().decode([User].self, from: Resource.users.data())
let postList = try JSONDecoder().decode([Post].self, from: Resource.posts.data())
let commentList = try JSONDecoder().decode([Comment].self, from: Resource.comments.data())

var postCommentMapping = [Int: Int]() // [postID: totalComments]
var userPostCommentMapping = [Int: (Int, Int)]() // [userId: (totalPosts, totalComments)]

for comment in commentList {
    let totalComments = (postCommentMapping[comment.postId] ?? 0) + 1
    postCommentMapping[comment.postId] = totalComments
}

for post in postList {
    let (totalPosts, totalComments) = userPostCommentMapping[post.userId] ?? (0, 0)
    userPostCommentMapping[post.userId] = (totalPosts + 1, totalComments + (postCommentMapping[post.id] ?? 0))
}

var firstHighestAverage: Float = 0
var secondHighestAverage: Float = 0
var thirdHighestAverage: Float = 0

var firstUser: User?
var secondUser: User?
var thirdUser: User?

for user in userList {

    let (totalPosts, totalComments) = userPostCommentMapping[user.id] ?? (0, 0)
    guard totalPosts > 0 else { continue }
    let average = Float(totalComments) / Float(totalPosts)

    if (average > firstHighestAverage) {

        thirdHighestAverage = secondHighestAverage
        secondHighestAverage = firstHighestAverage
        firstHighestAverage = average

        thirdUser = secondUser
        secondUser = firstUser
        firstUser = user

    } else if (average > secondHighestAverage) {

        thirdHighestAverage = secondHighestAverage
        secondHighestAverage = average

        thirdUser = secondUser
        secondUser = user

    } else if (average > thirdHighestAverage) {

        thirdHighestAverage = average
        thirdUser = user
    }
}

print("\(firstUser?.name ?? "") - \(firstUser?.id ?? 0), Score: \(firstHighestAverage)")
print("\(secondUser?.name ?? "") - \(secondUser?.id ?? 0), Score: \(secondHighestAverage)")
print("\(thirdUser?.name ?? "") - \(thirdUser?.id ?? 0), Score: \(thirdHighestAverage)")
