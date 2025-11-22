import api from './api';
import { NewsletterSubscription, PaginatedResponse } from '@/types';

// REMOVED: All mock data and localStorage - now using backend API only

export const newsletterService = {
  async subscribe(email: string): Promise<NewsletterSubscription> {
    const response = await api.post<{ success: boolean; data: NewsletterSubscription } | NewsletterSubscription>('/newsletters', { email });
    
    // Backend returns { success: true, data: subscription }
    if ((response.data as any).success && (response.data as any).data) {
      return (response.data as any).data;
    }
    
    return response.data as NewsletterSubscription;
  },

  async getSubscriptions(page = 1): Promise<PaginatedResponse<NewsletterSubscription>> {
    const response = await api.get<PaginatedResponse<NewsletterSubscription>>('/newsletters', {
      params: { page },
    });
    
    // Backend returns { success: true, data: [...], pagination: {...} }
    if ((response.data as any).success && (response.data as any).data) {
      return {
        data: (response.data as any).data,
        total: (response.data as any).pagination?.total || (response.data as any).data.length,
        page: (response.data as any).pagination?.page || page,
        limit: (response.data as any).pagination?.limit || 20,
        totalPages: (response.data as any).pagination?.totalPages || Math.ceil(((response.data as any).pagination?.total || (response.data as any).data.length) / 20),
      };
    }
    
    return response.data;
  },

  async unsubscribe(id: string): Promise<void> {
    await api.patch(`/newsletters/${id}/unsubscribe`);
  },

  async deleteSubscription(id: string): Promise<void> {
    await api.delete(`/newsletters/${id}`);
  },
};
