import api from './api';
import { Appointment, PaginatedResponse } from '@/types';

// REMOVED: All mock data and localStorage - now using backend API only

export const appointmentService = {
  async getAppointments(page = 1, filters?: { status?: string }): Promise<PaginatedResponse<Appointment>> {
    const response = await api.get<PaginatedResponse<Appointment>>('/appointments', {
      params: { page, ...filters },
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

  async getAppointmentById(id: string): Promise<Appointment> {
    const response = await api.get<{ success: boolean; data: Appointment } | Appointment>(`/appointments/${id}`);
    
    // Backend returns { success: true, data: appointment }
    if ((response.data as any).success && (response.data as any).data) {
      return (response.data as any).data;
    }
    
    return response.data as Appointment;
  },

  async updateAppointmentStatus(id: string, status: Appointment['status']): Promise<Appointment> {
    const response = await api.patch<{ success: boolean; data: Appointment } | Appointment>(`/appointments/${id}/status`, { status });
    
    // Backend returns { success: true, data: appointment }
    if ((response.data as any).success && (response.data as any).data) {
      return (response.data as any).data;
    }
    
    return response.data as Appointment;
  },

  async deleteAppointment(id: string): Promise<void> {
    await api.delete(`/appointments/${id}`);
  },
};
