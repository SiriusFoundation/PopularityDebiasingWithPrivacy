import numpy as np; np.random.seed(0)
import seaborn as sb
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap
import matplotlib as mpl
from matplotlib.cm import ScalarMappable
sb.set(style="darkgrid")

m_dataset_list = ["Yelp"]
# m_dataset_list = ["MLM", "DoubanBooks", "Yelp"]
m_file_list = ["Novelty"]
# m_file_list = ["APRI", "APLT", "Entropy", "F1", "LTC", "nDCG", "Novelty", "Precision", "Recall"]

m_give_y_axis = False
m_y_axis_min = 0.9
m_y_axis_max = 1.0

print("start!")

for m_data_Set in m_dataset_list:
    for m_file in m_file_list:
        print(m_data_Set, m_file)

        m_read_path = "../out/9_plot_prepare/" + m_data_Set + "/" +  m_file + ".csv"
        m_raw_dataset = pd.read_csv(m_read_path, delimiter=';')

        group_names = ['UU', 'BB', 'PP', 'FF']

        for i in range(0, len(group_names)):
            MP_plot_vals=m_raw_dataset.iloc[0].tolist()
            IA_plot_vals=m_raw_dataset.iloc[1].tolist()
            MMMF_plot_vals = m_raw_dataset.iloc[2].tolist()
            WMF_plot_vals = m_raw_dataset.iloc[3].tolist()
            HPF_plot_vals = m_raw_dataset.iloc[4].tolist()
            IBPR_plot_vals = m_raw_dataset.iloc[5].tolist()
            WBPR_plot_vals = m_raw_dataset.iloc[6].tolist()
            SKM_plot_vals = m_raw_dataset.iloc[7].tolist()
            NEUMF_plot_vals = m_raw_dataset.iloc[8].tolist()
            VAECF_plot_vals = m_raw_dataset.iloc[9].tolist()

        barWidth = 0.18
        bars1 = [MP_plot_vals[0], IA_plot_vals[0], MMMF_plot_vals[0],WMF_plot_vals[0],HPF_plot_vals[0],IBPR_plot_vals[0],WBPR_plot_vals[0],SKM_plot_vals[0],NEUMF_plot_vals[0],VAECF_plot_vals[0]]
        bars2 = [MP_plot_vals[1], IA_plot_vals[1], MMMF_plot_vals[1],WMF_plot_vals[1],HPF_plot_vals[1],IBPR_plot_vals[1],WBPR_plot_vals[1],SKM_plot_vals[1],NEUMF_plot_vals[1],VAECF_plot_vals[1]]
        bars3 = [MP_plot_vals[2], IA_plot_vals[2], MMMF_plot_vals[2],WMF_plot_vals[2],HPF_plot_vals[2],IBPR_plot_vals[2],WBPR_plot_vals[2],SKM_plot_vals[2],NEUMF_plot_vals[2],VAECF_plot_vals[2]]
        bars4 = [MP_plot_vals[3], IA_plot_vals[3], MMMF_plot_vals[3],WMF_plot_vals[3],HPF_plot_vals[3],IBPR_plot_vals[3],WBPR_plot_vals[3],SKM_plot_vals[3],NEUMF_plot_vals[3],VAECF_plot_vals[3]]

        r1 = np.arange(len(bars1))
        r2 = [x + barWidth for x in r1]
        r3 = [x + barWidth for x in r2]
        r4 = [x + barWidth for x in r3]

        patterns = [ "/" , "\\" , "|" , "-" , "+" , "x", "o", "O", ".", "*"]
        # Make the plot
        plt.bar(r1, bars1, width=barWidth, label='UU', hatch=patterns[0])
        plt.bar(r2, bars2, width=barWidth, label='BB', hatch=patterns[1])
        plt.bar(r3, bars3, width=barWidth, label='PP', hatch=patterns[2])
        plt.bar(r4, bars4, width=barWidth, label='FF', hatch=patterns[3])


        m_ylabel = m_file

        if (m_file == "F1"):
            m_ylabel = "F1-score"

        if (m_file == "nDCG"):
            m_ylabel = '$\it{n}$' + "DCG"

        # Add xticks on the middle of the group bars + show legend
        # plt.xlabel(m_data_Set + '_Algorithms', fontsize='14')
        #plt.ylabel(m_data_Set + "_" + m_file, fontsize='14')
        plt.ylabel(m_ylabel, fontsize='14')
        plt.xticks([r + barWidth + 0.1 for r in range(len(bars1))], ['MP','IA','MMMF','WMF','HPF','IBPR','WBPR','SKM','NEUMF','VAECF'], fontsize='13', rotation=60)
        plt.yticks(fontsize='10')
        plt.legend(bbox_to_anchor=(1.02, 1), loc=2, borderaxespad=0., framealpha=1, fontsize='12')

        if m_give_y_axis:
            plt.ylim((m_y_axis_min, m_y_axis_max))

        m_file_prefix = ""

        if (m_data_Set == "MLM"):
            m_file_prefix = "ML"

        if (m_data_Set == "DoubanBooks"):
            m_file_prefix = "DB"

        if (m_data_Set == "Yelp"):
            m_file_prefix = "Yelp"

        m_write_path = "../out/10_draw_plot/" + m_data_Set + "/" + m_file  + "_" + m_file_prefix + ".pdf"

        plt.savefig(m_write_path, dpi=300, bbox_inches='tight')

        plt.clf()
        plt.cla()

print(m_data_Set, m_file, "done!")