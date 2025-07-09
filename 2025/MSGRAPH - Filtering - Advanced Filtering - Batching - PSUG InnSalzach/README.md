# Level up your MSGraph skills

## Who am I?

<div style="display: flex; align-items: center; flex-wrap: wrap;">
  <div style="flex: 1; min-width: 250px;">
    Hello there! I'm **Morten Mynster**, an automation enthusiast, coder, and proud family man. My IT journey began back in 2017, and since then, I've been on a mission to simplify the complex through scripting and automation. Whether it's crafting workflows, managing systems, or experimenting with new technologies, I thrive on turning challenges into opportunities for innovation.
  </div>
  <div style="flex: 0 0 auto; margin-left: 20px;">
    <a href="/" id="avatar" class="rounded-circle">
      <img src="https://mynster9361.github.io/assets/img/posts/me.png" alt="Morten Mynster" style="border-radius: 50%; max-width: 100px; height: auto;">
    </a>
  </div>
</div>

When I'm not writing code or tinkering in my homelab, I'm spending time with my amazing wife, our two kids, and our Disney-inspired dog, Mushu (yes, like the dragon from *Mulan*). Outside of work, you'll find me gaming, exploring new ideas, or enjoying quality time with my family.

### What I Work On
I dedicate my time to mastering:
- **PowerShell**: Automating tasks, managing systems, and making the impossible possible.
- **Python**: Building robust scripts and developing creative automation solutions.
- **Terraform**: Harnessing the power of infrastructure as code to tame the cloud.
- **Homelabbing**: Creating, breaking, and rebuilding home lab environments to push the boundaries of learning.

### Projects and Interests
I'm passionate about sharing my journey and insights through my blog, where I dive into topics like:
- **Automation tools and techniques**: From PowerShell modules to rest api's.
- **Scripting best practices**: Writing clean, efficient, and reusable code (or at least trying :D).
- **Microsoft Graph API**: Exploring advanced techniques for data manipulation and automation.

Some of my recent blog posts on this subject include:
- [Filtering with Microsoft Graph API](https://mynster9361.github.io/posts/Filtering/)
  Demonstrating how to filter data when working with Microsoft Graph API.
- [Advanced Filtering with Microsoft Graph API](https://mynster9361.github.io/posts/AdvancedFiltering/)
  Exploring advanced filtering techniques and best practices.
- [Batch Requests in MS Graph](https://mynster9361.github.io/posts/BatchRequest/)
  Demonstrating how to use batch requests in MS Graph for improved performance.

Let's connect on [LinkedIn](https://www.linkedin.com/in/mortenmynster/) and [GitHub](https://github.com/Mynster9361) ! I'm always excited to meet like-minded professionals and exchange ideas.


## Description
This session will guide attendees through advanced techniques for interacting with the Microsoft Graph API using PowerShell. We'll explore practical examples, including handling pagination, filtering data, and making batch requests. Attendees will learn how to efficiently retrieve and manipulate data from Microsoft Graph, leveraging PowerShell scripts to automate tasks in cloud, hybrid, and on-premise environments. Whether you're a beginner or an experienced PowerShell user, this session will provide valuable insights and best practices to enhance your MSGraph skills.

## What You'll Learn

### 1. Pagination Handling (`1_NextPage.ps1`)
- Understanding OData pagination in Microsoft Graph
- Implementing proper pagination loops
- Best practices for retrieving all data pages

### 2. Throttling Management (`2_Throtling.ps1`)
- Understanding Microsoft Graph throttling limits
- Implementing retry logic with exponential backoff
- Handling 429 Too Many Requests errors
- Using Retry-After headers effectively

### 3. Data Filtering (`3_Filter.ps1`)
- Basic OData filtering techniques
- String operations with `startswith`, `endswith`, `contains`
- Date and time filtering
- Combining multiple filter conditions
- Working with boolean and numeric filters

### 4. Search Functionality (`4_Search.ps1`)
- Using `$search` parameter effectively
- Combining search with filters
- Understanding ConsistencyLevel requirements
- Advanced search patterns and operators

### 5. Advanced Filtering (`5_AdvancedFilters.ps1`)
- Working with complex nested properties
- Using `any()` and `all()` operations
- Advanced date filtering with relative dates
- Filtering collections and arrays
- Combining search and advanced filters

### 6. Batch Requests (`6_BatchRequests.ps1`)
- Understanding batch request limitations (max 20 requests)
- Structuring batch request bodies
- Handling batch response parsing
- Error handling in batch requests
- Performance optimization strategies

## Session Files

1. **`1_NextPage.ps1`** - Demonstrates pagination handling with user app role assignments
2. **`2_Throtling.ps1`** - Shows throttling management and retry logic
3. **`3_Filter.ps1`** - Basic filtering examples for users, groups, and service principals
4. **`4_Search.ps1`** - Search functionality with consistency level requirements
5. **`5_AdvancedFilters.ps1`** - Advanced filtering techniques with complex scenarios
6. **`6_BatchRequests.ps1`** - Batch request implementation and best practices

## Key Takeaways

By the end of this session, you'll be able to:
- ✅ Handle pagination correctly in Microsoft Graph API calls
- ✅ Implement proper throttling and retry mechanisms
- ✅ Use basic and advanced filtering to retrieve specific data
- ✅ Leverage search functionality for complex queries
- ✅ Optimize performance using batch requests
- ✅ Apply best practices for Microsoft Graph API automation

## Additional Resources

- **Original PDQ Talk Repository:** [MSGraph Filtering - Advanced Filtering](https://github.com/Mynster9361/PDQ-Talk/tree/main/MSGRAPH%20-%20Filtering%20-%20Advanced%20Fitlering)
- **Blog Posts:**
  - [Filtering with Microsoft Graph API](https://mynster9361.github.io/posts/Filtering/)
  - [Advanced Filtering with Microsoft Graph API](https://mynster9361.github.io/posts/AdvancedFiltering/)
  - [Batch Requests in MS Graph](https://mynster9361.github.io/posts/BatchRequest/)
- **Microsoft Documentation:**
  - [Microsoft Graph API Documentation](https://docs.microsoft.com/en-us/graph/)
  - [OData Query Parameters](https://docs.microsoft.com/en-us/graph/query-parameters)
  - [Microsoft Graph Best Practices](https://docs.microsoft.com/en-us/graph/best-practices-concept)

## Questions & Feedback

This is one of my first speaking engagements outside of the PowerShell Wednesdays, so I'd love to hear your feedback! Feel free to:
- Connect with me on [LinkedIn](https://www.linkedin.com/in/mortenmynster/)
- Check out my [GitHub](https://github.com/Mynster9361)
- Visit my [blog](https://mynster9361.github.io/)

Thank you for joining me on this journey to level up your MSGraph skills! 🚀
