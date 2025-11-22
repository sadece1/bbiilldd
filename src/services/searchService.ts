import { Gear } from '@/types';
import { BlogPost } from '@/types';
import { blogService } from './blogService';
import { gearService } from './gearService';

export interface SearchResult {
  blogs: Array<{
    id: string;
    title: string;
    excerpt: string;
    image: string;
    category: string;
  }>;
  gear: Gear[];
}

export const searchService = {
  async search(query: string): Promise<SearchResult> {
    const lowerQuery = query.toLowerCase().trim();

    if (lowerQuery.length < 2) {
      return { blogs: [], gear: [] };
    }

    // Search blogs from backend
    let blogResults: Array<{
      id: string;
      title: string;
      excerpt: string;
      image: string;
      category: string;
    }> = [];
    
    try {
      const blogsResponse = await blogService.getBlogs({ search: query }, 1);
      blogResults = blogsResponse.data
        .map((blog) => ({
          id: blog.id,
          title: blog.title,
          excerpt: blog.excerpt,
          image: blog.image || '',
          category: blog.category || '',
        }))
        .slice(0, 10); // Limit to 10 results
    } catch (error) {
      console.error('Failed to search blogs:', error);
    }

    // Search gear from backend
    let gearResults: Gear[] = [];
    try {
      const gearResponse = await gearService.getGear({ search: query }, 1, 100);
      gearResults = gearResponse.data.slice(0, 10); // Limit to 10 results
    } catch (error) {
      console.error('Failed to search gear:', error);
    }

    return {
      blogs: blogResults,
      gear: gearResults,
    };
  },
};
