import Link from "next/link";
import React from "react";

/**
 * @title FirstPost component
 */
class FirstPost extends React.Component {
    render(): React.ReactNode {
        return (
            <section>
                <h1>First Post</h1>
                <Link href="/">Return Home</Link>
            </section>
        )
    }
}

export default FirstPost;