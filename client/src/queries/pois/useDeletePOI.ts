import { useMutation } from "@tanstack/react-query";

import { MUTATION_KEYS, QUERY_KEYS, SERVER_URL } from "../../consts";

import axios from "../axios";
import { queryClient } from "../queryClient";

export const useDeletePOI = () => {
  return useMutation({
    mutationKey: [MUTATION_KEYS.DELETE_POI],
    mutationFn: async ({ id }: { id: string }) =>
      await axios.delete(`${SERVER_URL}/api/pois?id=eq.${id}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [QUERY_KEYS.GET_ROUTE_POIS] });
    },
  });
};
