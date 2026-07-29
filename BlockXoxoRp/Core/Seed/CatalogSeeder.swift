import Foundation

enum CatalogSeeder {
    static func seed() {
        let now = Date().timeIntervalSince1970

        let privileged = UserProfile(
            id: "seed_master",
            email: CurrentUserSession.privilegedEmail,
            password: CurrentUserSession.privilegedPassword,
            nickname: "BrickMaster",
            handle: "BrickMaster",
            avatarName: "avatar_01",
            bio: "Creating futuristic cities and detailed MOCs. Love turning imagination into bricks.",
            title: "Master Builder",
            coins: 100,
            followingIds: ["u1", "u2", "u3"],
            followerIds: ["u1", "u2", "u3", "u4"],
            friendIds: ["u1", "u2", "u3"],
            likedPostIds: ["p_u1", "p_u2"],
            blockedIds: [],
            joinedCrewIds: ["crew1", "crew2"],
            isPrivileged: true,
            createdAt: now - 86400 * 40
        )

        let catalog: [UserProfile] = [
            UserProfile(id: "u1", email: "alex.brick@brickverse.app", password: "brick888", nickname: "Alex_Brick", handle: "Alex_Brick", avatarName: "avatar_02", bio: "Tokyo streets and ramen shops in bricks.", title: "Street Architect", coins: 40, followingIds: ["seed_master", "u2"], followerIds: ["seed_master", "u3"], friendIds: ["seed_master"], likedPostIds: [], blockedIds: [], joinedCrewIds: ["crew1"], isPrivileged: false, createdAt: now - 86400 * 30),
            UserProfile(id: "u2", email: "pixel.mason@brickverse.app", password: "brick888", nickname: "PixelMason", handle: "PixelMason", avatarName: "avatar_03", bio: "City blocks and skyline studies.", title: "City Planner", coins: 35, followingIds: ["seed_master", "u1"], followerIds: ["seed_master", "u4"], friendIds: ["seed_master"], likedPostIds: [], blockedIds: [], joinedCrewIds: ["crew2"], isPrivileged: false, createdAt: now - 86400 * 28),
            UserProfile(id: "u3", email: "neon.builder@brickverse.app", password: "brick888", nickname: "NeonBuilder", handle: "NeonBuilder", avatarName: "avatar_04", bio: "Cyber towers with neon rooftops.", title: "Neon Artist", coins: 28, followingIds: ["u1", "seed_master"], followerIds: ["seed_master"], friendIds: ["seed_master"], likedPostIds: [], blockedIds: [], joinedCrewIds: ["crew1"], isPrivileged: false, createdAt: now - 86400 * 20),
            UserProfile(id: "u4", email: "tiny.lab@brickverse.app", password: "brick888", nickname: "TinyBrickLab", handle: "TinyBrickLab", avatarName: "avatar_05", bio: "Micro-scale builds under 500 pieces.", title: "Micro Builder", coins: 22, followingIds: ["u2"], followerIds: ["seed_master", "u5"], friendIds: [], likedPostIds: [], blockedIds: [], joinedCrewIds: ["crew3"], isPrivileged: false, createdAt: now - 86400 * 15),
            UserProfile(id: "u5", email: "castle.craft@brickverse.app", password: "brick888", nickname: "CastleCraft", handle: "CastleCraft", avatarName: "avatar_06", bio: "Medieval keeps and river bridges.", title: "Castle Keeper", coins: 18, followingIds: ["u4"], followerIds: ["u1"], friendIds: [], likedPostIds: [], blockedIds: [], joinedCrewIds: ["crew2"], isPrivileged: false, createdAt: now - 86400 * 10)
        ]

        var users = [privileged] + catalog

        let posts: [BrickPost] = [
            BrickPost(id: "p_seed", authorId: "seed_master", title: "Cyber City Tower", body: "Finished my Cyber City Tower! 3000+ bricks, 18 hours of building. The neon rooftop was the hardest part.", imageName: "post_1", tag: "#Architecture", likeCount: 4, commentCount: 3, likedBy: ["u1", "u2", "u3", "u4"], createdAt: now - 7200, crewId: "crew1"),
            BrickPost(id: "p_u1", authorId: "u1", title: "Tokyo Street Corner", body: "Built a tiny Japanese street with a ramen shop, bookstore and hidden details. Took 16 hours to complete!", imageName: "post_2", tag: "#Architecture", likeCount: 3, commentCount: 2, likedBy: ["seed_master", "u2", "u3"], createdAt: now - 10000, crewId: "crew1"),
            BrickPost(id: "p_u2", authorId: "u2", title: "Harbor Crane Yard", body: "Industrial harbor with working crane arms. Studded containers stacked for night lighting tests.", imageName: "post_3", tag: "#City", likeCount: 5, commentCount: 4, likedBy: ["seed_master", "u1", "u3", "u4", "u5"], createdAt: now - 20000, crewId: "crew2"),
            BrickPost(id: "p_u3", authorId: "u3", title: "Neon Alley Run", body: "Rainy neon alley MOC — reflective tiles and floating signs. Looking for feedback on the color balance.", imageName: "post_4", tag: "#Cyber", likeCount: 2, commentCount: 2, likedBy: ["u1", "seed_master"], createdAt: now - 30000, crewId: "crew1"),
            BrickPost(id: "p_u4", authorId: "u4", title: "Pocket Observatory", body: "Micro observatory dome under 400 pieces. Perfect desk companion for late-night build sessions.", imageName: "post_5", tag: "#Micro", likeCount: 4, commentCount: 3, likedBy: ["u5", "u2", "seed_master", "u1"], createdAt: now - 40000, crewId: "crew3"),
            BrickPost(id: "p_u5", authorId: "u5", title: "River Keep Bridge", body: "Stone keep guarding a brick river. Gatehouse hinges and ivy slopes still WIP.", imageName: "post_6", tag: "#Castle", likeCount: 3, commentCount: 2, likedBy: ["u4", "u1", "u2"], createdAt: now - 50000, crewId: "crew2")
        ]

        let comments: [PostComment] = [
            PostComment(id: "c1", postId: "p_seed", authorId: "u1", body: "The neon roof lighting is incredible!", createdAt: now - 6000),
            PostComment(id: "c2", postId: "p_seed", authorId: "u2", body: "How did you support those overhangs?", createdAt: now - 5000),
            PostComment(id: "c3", postId: "p_seed", authorId: "u3", body: "Saving this for my next cyber MOC.", createdAt: now - 4000),
            PostComment(id: "c4", postId: "p_u1", authorId: "seed_master", body: "Ramen shop details are next level.", createdAt: now - 9000),
            PostComment(id: "c5", postId: "p_u1", authorId: "u3", body: "Love the lantern glow!", createdAt: now - 8000),
            PostComment(id: "c6", postId: "p_u2", authorId: "u1", body: "Crane articulation looks solid.", createdAt: now - 18000),
            PostComment(id: "c7", postId: "p_u2", authorId: "u4", body: "Those containers make great scale.", createdAt: now - 17000),
            PostComment(id: "c8", postId: "p_u2", authorId: "seed_master", body: "Night lighting tip: cheese slopes as reflectors.", createdAt: now - 16000),
            PostComment(id: "c9", postId: "p_u2", authorId: "u5", body: "Want a castle harbor collab?", createdAt: now - 15000),
            PostComment(id: "c10", postId: "p_u3", authorId: "u2", body: "Color balance feels cinematic.", createdAt: now - 28000),
            PostComment(id: "c11", postId: "p_u3", authorId: "u4", body: "Try translucent tiles for puddles.", createdAt: now - 27000),
            PostComment(id: "c12", postId: "p_u4", authorId: "u5", body: "Desk MOC goals!", createdAt: now - 38000),
            PostComment(id: "c13", postId: "p_u4", authorId: "u1", body: "Under 400 pieces is impressive.", createdAt: now - 37000),
            PostComment(id: "c14", postId: "p_u4", authorId: "seed_master", body: "Micro builds always inspire me.", createdAt: now - 36000),
            PostComment(id: "c15", postId: "p_u5", authorId: "u2", body: "Ivy slopes look natural.", createdAt: now - 48000),
            PostComment(id: "c16", postId: "p_u5", authorId: "u4", body: "Bridge arch technique please!", createdAt: now - 47000)
        ]

        let crews: [BrickCrew] = [
            BrickCrew(id: "crew1", name: "Architecture Lovers", coverName: "post_7", memberCount: 18, about: "Share city blocks, facades, and street MOCs."),
            BrickCrew(id: "crew2", name: "Castle & Harbor", coverName: "post_8", memberCount: 14, about: "Medieval keeps, ships, and waterfront builds."),
            BrickCrew(id: "crew3", name: "Micro Scale Lab", coverName: "post_9", memberCount: 11, about: "Tiny builds that fit in your palm.")
        ]

        let threads: [ChatThread] = [
            ChatThread(id: "t1", peerId: "u1", lastText: "Your Tokyo street lighting tips helped a lot!", updatedAt: now - 3600, unread: 2, subtitle: "Tokyo Street Corner"),
            ChatThread(id: "t2", peerId: "u2", lastText: "Harbor crane gears are trickier than they look.", updatedAt: now - 7200, unread: 1, subtitle: "Harbor Crane Yard"),
            ChatThread(id: "t3", peerId: "u3", lastText: "Want to join a neon alley build night?", updatedAt: now - 10800, unread: 3, subtitle: "Neon Alley Run")
        ]

        let bubbles: [ChatBubble] = [
            ChatBubble(id: "b1", threadId: "t1", senderId: "u1", text: "Hey BrickMaster! Loved the Cyber City Tower.", createdAt: now - 8000),
            ChatBubble(id: "b2", threadId: "t1", senderId: "seed_master", text: "Thanks! Your ramen shop tiles inspired the plaza.", createdAt: now - 7000),
            ChatBubble(id: "b3", threadId: "t1", senderId: "u1", text: "Your Tokyo street lighting tips helped a lot!", createdAt: now - 3600),
            ChatBubble(id: "b4", threadId: "t2", senderId: "u2", text: "Working on container stacks tonight.", createdAt: now - 9000),
            ChatBubble(id: "b5", threadId: "t2", senderId: "seed_master", text: "Try hinge plates for crane rotation.", createdAt: now - 8500),
            ChatBubble(id: "b6", threadId: "t2", senderId: "u2", text: "Harbor crane gears are trickier than they look.", createdAt: now - 7200),
            ChatBubble(id: "b7", threadId: "t3", senderId: "u3", text: "Neon translucent parts or stickers?", createdAt: now - 12000),
            ChatBubble(id: "b8", threadId: "t3", senderId: "seed_master", text: "Trans-neon green plates under clear tiles.", createdAt: now - 11000),
            ChatBubble(id: "b9", threadId: "t3", senderId: "u3", text: "Want to join a neon alley build night?", createdAt: now - 10800)
        ]

        // Align follower graphs on catalog side for privileged follows
        for i in users.indices {
            if users[i].id == "u1" || users[i].id == "u2" || users[i].id == "u3" {
                if !users[i].followingIds.contains("seed_master") {
                    users[i].followingIds.append("seed_master")
                }
            }
        }

        LocalStore.shared.save(users, file: StoreFile.users)
        LocalStore.shared.save(posts, file: StoreFile.posts)
        LocalStore.shared.save(comments, file: StoreFile.comments)
        LocalStore.shared.save(crews, file: StoreFile.crews)
        LocalStore.shared.save(threads, file: StoreFile.threads)
        LocalStore.shared.save(bubbles, file: StoreFile.bubbles)
    }
}
