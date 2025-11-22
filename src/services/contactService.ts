import api from './api';
import { ContactForm, AppointmentForm } from '@/types';

// REMOVED: All mock data and localStorage - now using backend API only

export const contactService = {
  async sendMessage(data: ContactForm): Promise<void> {
      await api.post('/contact', data);
  },
  
  async bookAppointment(data: AppointmentForm): Promise<void> {
      await api.post('/appointments', data);
  },
      };
