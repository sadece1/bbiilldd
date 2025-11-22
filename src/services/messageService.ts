import api from './api';
import { Message, PaginatedResponse } from '@/types';

// REMOVED: All mock data and localStorage - now using backend API only

export const messageService = {
  async getMessages(page = 1): Promise<PaginatedResponse<Message>> {
    const response = await api.get<PaginatedResponse<Message>>('/messages', {
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

  async getMessageById(id: string): Promise<Message> {
    const response = await api.get<{ success: boolean; data: Message } | Message>(`/messages/${id}`);
    
    // Backend returns { success: true, data: message }
    if ((response.data as any).success && (response.data as any).data) {
      return (response.data as any).data;
    }
    
    return response.data as Message;
  },

  async markAsRead(id: string): Promise<Message> {
    const response = await api.patch<{ success: boolean; data: Message } | Message>(`/messages/${id}/read`);
    
    // Backend returns { success: true, data: message }
    if ((response.data as any).success && (response.data as any).data) {
      return (response.data as any).data;
    }
    
    return response.data as Message;
  },

  async deleteMessage(id: string): Promise<void> {
    await api.delete(`/messages/${id}`);
  },
};
